package routes

import (
	"net/http"

	"github.com/gin-gonic/gin"
	// "github.com/EdgeJay/lifecyclebot/telegram/env"
	// awsUtils "github.com/EdgeJay/lifecyclebot/utils/aws"
)

func NewRouter() *gin.Engine {
	// create router
	router := gin.Default()

	router.GET("/", func(ctx *gin.Context) {
		ctx.JSON(http.StatusOK,
			gin.H{
				"status": "ok",
				// "bot_token": awsUtils.GetStringParameter(env.GetAWSParamStoreKeyName("telegram_bot_token"), ""),
			},
		)
	})

	return router
}
