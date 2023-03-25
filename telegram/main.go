package main

import (
	"context"
	"fmt"
	"log"
	"net/http"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	ginadapter "github.com/awslabs/aws-lambda-go-api-proxy/gin"

	"github.com/EdgeJay/lifecyclebot/telegram/routes"
	lambdaUtils "github.com/EdgeJay/lifecyclebot/utils/lambda"
)

var ginLambda *ginadapter.GinLambda

func handler(ctx context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	// stdout and stderr are sent to AWS CloudWatch Logs
	log.Printf("Processing Lambda request %v\n", request.RequestContext)
	return ginLambda.ProxyWithContext(ctx, request)
}

func main() {
	log.Printf("Start lambda")

	if lambdaUtils.IsRunningInLambda() {
		ginLambda = ginadapter.New(routes.NewRouter())
		lambda.Start(handler)
	} else {
		fmt.Println("running aws lambda in local")
		log.Fatal(http.ListenAndServe(":8080", routes.NewRouter()))
	}
}
