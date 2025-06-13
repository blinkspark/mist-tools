package main

import (
	"bytes"
	"image/png"
	"log"
	"os"

	"crawshaw.io/sqlite"
	"crawshaw.io/sqlite/sqlitex"
	"github.com/dchest/captcha"
	"github.com/gofiber/fiber/v3"
	"golang.org/x/crypto/bcrypt"
)

type User struct {
	ID       int64  `json:"id"`
	Username string `json:"username"`
	Password string `json:"password"`
}

func main() {
	dbPath := "users.db"
	conn, err := sqlite.OpenConn(dbPath, sqlite.SQLITE_OPEN_CREATE|sqlite.SQLITE_OPEN_READWRITE)
	if err != nil {
		log.Fatal(err)
	}
	defer conn.Close()

	// 创建表
	err = sqlitex.Exec(conn, `CREATE TABLE IF NOT EXISTS users (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		username TEXT UNIQUE,
		password TEXT
	)`, nil)
	if err != nil {
		log.Fatal(err)
	}

	app := fiber.New()

	app.Post("/register", func(c fiber.Ctx) error {
		var req struct {
			Username  string `json:"username"`
			Password  string `json:"password"`
			CaptchaId string `json:"captcha_id"`
			Captcha   string `json:"captcha"`
		}
		if err := c.Bind().Body(&req); err != nil {
			return c.Status(400).JSON(fiber.Map{"error": "参数错误"})
		}
		if req.Username == "" || req.Password == "" {
			return c.Status(400).JSON(fiber.Map{"error": "用户名和密码不能为空"})
		}
		if req.CaptchaId == "" || req.Captcha == "" {
			return c.Status(400).JSON(fiber.Map{"error": "验证码不能为空"})
		}
		if !captcha.VerifyString(req.CaptchaId, req.Captcha) {
			return c.Status(400).JSON(fiber.Map{"error": "验证码错误"})
		}
		// 密码加密
		hash, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
		if err != nil {
			return c.Status(500).JSON(fiber.Map{"error": "密码加密失败"})
		}
		stmt := conn.Prep("INSERT INTO users(username, password) VALUES (?, ?)")
		stmt.BindText(1, req.Username)
		stmt.BindText(2, string(hash))
		_, err = stmt.Step()
		stmt.Reset()
		if err != nil {
			return c.Status(400).JSON(fiber.Map{"error": "用户名已存在"})
		}
		return c.JSON(fiber.Map{"msg": "注册成功"})
	})

	app.Post("/login", func(c fiber.Ctx) error {
		var req struct {
			Username  string `json:"username"`
			Password  string `json:"password"`
			CaptchaId string `json:"captcha_id"`
			Captcha   string `json:"captcha"`
		}
		if err := c.Bind().Body(&req); err != nil {
			return c.Status(400).JSON(fiber.Map{"error": "参数错误"})
		}
		if req.CaptchaId == "" || req.Captcha == "" {
			return c.Status(400).JSON(fiber.Map{"error": "验证码不能为空"})
		}
		if !captcha.VerifyString(req.CaptchaId, req.Captcha) {
			return c.Status(400).JSON(fiber.Map{"error": "验证码错误"})
		}
		stmt := conn.Prep("SELECT id, password FROM users WHERE username=?")
		stmt.BindText(1, req.Username)
		row, err := stmt.Step()
		if err != nil {
			return c.Status(500).JSON(fiber.Map{"error": "数据库错误"})
		}
		if row {
			id := stmt.ColumnInt64(0)
			hash := stmt.ColumnText(1)
			if bcrypt.CompareHashAndPassword([]byte(hash), []byte(req.Password)) == nil {
				return c.JSON(fiber.Map{"msg": "登录成功", "user_id": id})
			}
		}
		return c.Status(401).JSON(fiber.Map{"error": "用户名或密码错误"})
	})

	// 验证码图片路由
	app.Get("/captcha/:captchaId", func(c fiber.Ctx) error {
		captchaId := c.Params("captchaId")
		if captchaId == "" {
			return c.Status(400).SendString("缺少captchaId")
		}
		c.Set("Content-Type", "image/png")
		img := captcha.NewImage(captchaId, captcha.RandomDigits(6), 120, 40)
		buf := new(bytes.Buffer)
		if err := png.Encode(buf, img); err != nil {
			return c.Status(500).SendString("生成验证码图片失败")
		}
		return c.Send(buf.Bytes())
	})

	// 获取验证码ID
	app.Get("/captcha", func(c fiber.Ctx) error {
		captchaId := captcha.New()
		return c.JSON(fiber.Map{"captcha_id": captchaId})
	})

	port := os.Getenv("PORT")
	if port == "" {
		port = "22333"
	}
	log.Fatal(app.Listen(":" + port))
}
