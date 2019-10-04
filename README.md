# Dockerfile for simslides which is a presentation using Gazebo
[simslides](https://github.com/chapulina/simslides)を使うためのDockerfile．

## usage
1. git clone
2. make build
    * docker buildが実行される．長い．
3. make bash
    * docker run が実行される．その後の使い方は[simslides](https://github.com/chapulina/simslides)を見てください
    * Makefile内のMOUNT変数を適宜変更すること．presentationに使いたいpdfが入ってるディレクトリをマウントする
