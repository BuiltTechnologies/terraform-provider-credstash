VERSION = $(shell git tag --sort=version:refname  | tail -1)

build:
	go build -v -i -o terraform-provider-credstash

test:
	go test ./...

install: build
	mkdir -p ~/.terraform.d/plugins
	cp terraform-provider-credstash ~/.terraform.d/plugins/terraform-provider-credstash_$(VERSION)

release:
	GOOS=linux GOARCH=amd64 go build -o terraform-provider-credstash_$(VERSION)_linux_amd64
	GOOS=linux GOARCH=arm64 go build -o terraform-provider-credstash_$(VERSION)_linux_arm64
	GOOS=darwin GOARCH=amd64 go build -o terraform-provider-credstash_$(VERSION)_darwin_amd64
	GOOS=darwin GOARCH=arm64 go build -o terraform-provider-credstash_$(VERSION)_darwin_arm64
	
