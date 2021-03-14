install-protoc:
	brew install swift-protobuf

generate-networking:
	protoc  --grpc-swift_out=Client=true,Server=false:. --grpc-swift_opt=Visibility=Public backend-endpoints/*.proto \
		&& protoc --swift_out=. --swift_opt=Visibility=Public backend-endpoints/*.proto \
		&& mv -f backend-endpoints/*.swift Sources/Service/NetworkService/generated
