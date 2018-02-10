# build image
FROM golang:onbuild

# prepare and copy content
ARG pkg=github.com/ColorfulBridge/IndoorMapTileServer
COPY . $GOPATH/src/$pkg

# get dependencies and install
WORKDIR $GOPATH/src/$pkg
RUN go get
RUN go install

###################### RUN #############################
#run image
FROM golang:alpine

COPY --from=0 /go/bin/IndoorMapTileServer /go/bin/IndoorMapTileServer
COPY .keys/colorful-bridge_servicekey.json /root/service_key.json
ENV GOOGLE_APPLICATION_CREDENTIALS /root/service_key.json
ENV GCLOUD_STORAGE_BUCKET colorful-bridge-mapcontent

WORKDIR $GOPATH/src/$pkg

CMD IndoorMapTileServer