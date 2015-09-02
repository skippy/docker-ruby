NAME = skippy/ruby
VERSION = 2.2

all: build

build:
	docker build -t $(NAME):$(VERSION) .

test:
	docker run $(NAME):$(VERSION) ruby -e 'puts "Hello world"'

tag_latest:
	docker tag -f $(NAME):$(VERSION) $(NAME):latest

# FIXME: right now this triggers a build of all versions... we should probably trigger
# just a specific release
release: test tag_latest
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	curl -H "Content-Type: application/json" --data '{"build": true};' -X POST https://registry.hub.docker.com/u/skippy/ruby/trigger/2a257f9d-0133-489d-abb1-b94da2baef3b/
