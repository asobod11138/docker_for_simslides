# Dockerfile for simslides which is a presentation using Gazebo
simslidesを使うためのDockerfile

## usage
1. git clone
2. make build
    * docker buildが実行される．長い．
3. make bash
    * docker run が実行される．
    * Makefile内のMOUNT変数を適宜変更すること．presentationに使いたいpdfが入ってるディレクトリをマウントする
