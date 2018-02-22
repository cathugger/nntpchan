REPO=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
REPO_GOPATH=$(REPO)/go
MINIFY=$(REPO_GOPATH)/bin/minify
JS=$(REPO)/contrib/static/nntpchan.js
CONTRIB_JS=$(REPO)/contrib/js/contrib
LOCAL_JS=$(REPO)/contrib/js/nntpchan
VENDOR_JS=$(REPO)/contrib/js/vendor
SRND_DIR=$(REPO)/contrib/backends/srndv2
NNTPCHAND_DIR=$(REPO)/contrib/backends/nntpchand
NNTPCHAN_DAEMON_DIR=$(REPO)/contrib/backends/nntpchan-daemon
SRND=$(REPO)/srndv2
NNTPCHAND=$(REPO)/nntpchand
NNTPD=$(REPO)/nntpd

GOROOT=$(shell go env GOROOT)
GO=$(GOROOT)/bin/go

<<<<<<< HEAD
GOPHERJS_GOROOT ?= $(GOROOT)
GOPHERJS_GO = $(GOPHERJS_GOROOT)/bin/go

GOPHERJS_GOPATH=$(REPO)/gopherjs_go
GOPHERJS=$(GOPHERJS_GOPATH)/bin/gopherjs

=======
>>>>>>> parent of c342687... re add pow captcha (initial)
all: clean build

build: js srnd

full: clean full-build

full-build: srnd beta native

js: $(JS)

srnd: $(SRND)

$(MINIFY):
<<<<<<< HEAD
	GOPATH=$(REPO_GOPATH) $(GO) get -v github.com/tdewolff/minify/cmd/minify

$(GOPHERJS):
	GOROOT=$(GOPHERJS_GOROOT) GOPATH=$(GOPHERJS_GOPATH) $(GOPHERJS_GO) get -v github.com/gopherjs/gopherjs

js-deps: $(MINIFY) $(MINER_JS)

$(MINER_JS): $(GOPHERJS) $(MINIFY)
	cp -rf $(SRND_DIR)/src/github.com $(GOPHERJS_GOPATH)/src/
	GOROOT=$(GOPHERJS_GOROOT) GOPATH=$(GOPHERJS_GOPATH) $(GOPHERJS) -m -v build github.com/ZiRo-/cuckgo/miner_js
	$(MINIFY) --mime=text/javascript > $(STATIC_DIR)/miner-js.js < miner_js.js
	rm -f miner_js.js.map miner_js.js
=======
	GOPATH=$(REPO_GOPATH) go get -v github.com/tdewolff/minify/cmd/minify

js-deps: $(MINIFY)
>>>>>>> parent of c342687... re add pow captcha (initial)

$(JS): js-deps
	rm -f $(JS)
	for f in $(CONTRIB_JS)/*.js ; do $(MINIFY) --mime=text/javascript >> $(JS) < $$f ; done
	$(MINIFY) --mime=text/javascript >> $(JS) < $(REPO)/contrib/js/entry.js
	for f in $(LOCAL_JS)/*.js ; do $(MINIFY) --mime=text/javascript >> $(JS) < $$f ; done
	for f in $(VENDOR_JS)/*.js ; do $(MINIFY) --mime=text/javascript >> $(JS) < $$f ; done


$(SRND):
	GOROOT=$(GOROOT) $(MAKE) -C $(SRND_DIR)
	cp $(SRND_DIR)/srndv2 $(SRND)

beta: $(NNTPCHAND)

$(NNTPCHAND):
	GOROOT=$(GOROOT) $(MAKE) -C $(NNTPCHAND_DIR)
	cp $(NNTPCHAND_DIR)/nntpchand $(NNTPCHAND)

native: $(NNTPD)

$(NNTPD):
	$(MAKE) -C $(NNTPCHAN_DAEMON_DIR)
	cp $(NNTPCHAN_DAEMON_DIR)/nntpd $(NNTPD)

test: test-srnd

test-full: test-srnd test-beta test-native

test-srnd:
	GOROOT=$(GOROOT) $(MAKE) -C $(SRND_DIR) test

test-beta:
	GOROOT=$(GOROOT) $(MAKE) -C $(NNTPCHAND_DIR) test

test-native:
	GOROOT=$(GOROOT) $(MAKE) -C $(NNTPCHAN_DAEMON_DIR) test


clean: clean-js clean-srnd

clean-full: clean clean-beta clean-native

clean-srnd:
	rm -f $(SRND)
	GOROOT=$(GOROOT) $(MAKE) -C $(SRND_DIR) clean

clean-js:
	rm -f $(JS)

clean-beta:
	rm -f $(NNTPCHAND)
	GOROOT=$(GOROOT) $(MAKE) -C $(NNTPCHAND_DIR) clean

clean-native:
	rm -f $(NNTPD)
	$(MAKE) -C $(NNTPCHAN_DAEMON_DIR) clean

distclean: clean
	rm -rf $(REPO_GOPATH)
