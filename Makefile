all: build

build:
	@fluent-gem build ./fluent-plugin-dummyjson.gemspec

clean:
	@rm -i fluent-plugin-dummyjson-*.gem

uninstall:
	@fluent-gem uninstall fluent-plugin-dummyjson
