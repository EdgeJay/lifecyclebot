package routes

import (
	"log"
	"net/http"

	"github.com/EdgeJay/lifecyclebot/telegram/env"
	"github.com/gin-gonic/gin"
)

func NewRouter() *gin.Engine {
	// create router
	router := gin.Default()

	router.GET("/", func(ctx *gin.Context) {
		ctx.JSON(http.StatusOK,
			gin.H{
				"status": "ok",
			},
		)
	})

	botToken, err := env.GetTelegramBotToken()
	if err != nil {
		log.Fatalln(err)
	}
	router.POST("/bot"+botToken, Webhook)

	return router
}
