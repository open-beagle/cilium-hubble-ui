# Cilium/Hubble UI

<https://github.com/cilium/hubble-ui>

```bash
git remote add upstream git@github.com:cilium/hubble-ui.git

git fetch upstream

git merge v0.11.0
```

## debug

```bash
# 安装Nodejs包
yarn

# 编译前端程序frontend
yarn build

# 调试前端程序
## 运行命令
yarn watch:client

## 访问地址，注意必须同时开启后端程序调试
http://localhost:8080

# 调试后端程序
## 1.复制.beagle/launch.json至.vscode/launch.json
## 2.F5启动调试
http://localhost:9090
```

## build

```bash
# patch
docker run -it --rm \
-v $PWD/:/go/src/gitlab.wodcloud.com/open-beagle/cilium-hubble-ui \
-w /go/src/gitlab.wodcloud.com/open-beagle/cilium-hubble-ui \
registry.cn-qingdao.aliyuncs.com/wod/git:2 \
git apply .beagle/v0.11.0-fix-path.patch && \
git apply .beagle/v0.11.0-install-grpc.patch

# build
docker run --rm -it \
-v $PWD/:/go/src/gitlab.wodcloud.com/open-beagle/cilium-hubble-ui \
-w /go/src/gitlab.wodcloud.com/open-beagle/cilium-hubble-ui \
registry.cn-qingdao.aliyuncs.com/wod/node:18-alpine \
bash -c 'yarn && yarn build'
```

## cache

```bash
# 构建缓存-->推送缓存至服务器
docker run --rm \
  -e PLUGIN_REBUILD=true \
  -e PLUGIN_ENDPOINT=$PLUGIN_ENDPOINT \
  -e PLUGIN_ACCESS_KEY=$PLUGIN_ACCESS_KEY \
  -e PLUGIN_SECRET_KEY=$PLUGIN_SECRET_KEY \
  -e DRONE_REPO_OWNER="open-beagle" \
  -e DRONE_REPO_NAME="cilium-hubble-ui" \
  -e PLUGIN_MOUNT="./node_modules" \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  registry.cn-qingdao.aliyuncs.com/wod/devops-s3-cache:1.0

# 读取缓存-->将缓存从服务器拉取到本地
docker run --rm \
  -e PLUGIN_RESTORE=true \
  -e PLUGIN_ENDPOINT=$PLUGIN_ENDPOINT \
  -e PLUGIN_ACCESS_KEY=$PLUGIN_ACCESS_KEY \
  -e PLUGIN_SECRET_KEY=$PLUGIN_SECRET_KEY \
  -e DRONE_REPO_OWNER="open-beagle" \
  -e DRONE_REPO_NAME="cilium-hubble-ui" \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  registry.cn-qingdao.aliyuncs.com/wod/devops-s3-cache:1.0
```
