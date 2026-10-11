# KeiMi PersistentClock

基于 **KeiMi 2.5.0+067bd4c8** 的状态栏时间与电池信息常驻补丁。

开启「系统界面 → 双排时间与电池状态」后，让时间与电池信息同时显示。原有 **1 / 2 / 3 秒**设置控制电池数据采样频率；系统更新单行时间文字时，补丁会同时带上缓存的电池信息。

这是针对指定 APK 的 Smali 补丁项目，包含新增 Hook 和修改脚本，不是 KeiMi 的完整 Kotlin/Java 源码。原版 APK、测试 APK 和签名私钥不包含在本仓库中。

## 基线

- 包名：`os.kei.keimi`
- 原版文件：`KeiMi_2.5.0+067bd4c8.apk`
- 原版 SHA-256：`af760d6ae1ae0e34fb08cfb444ac646c1609194c6bb440b8e148fe65eb8fd37c`
- 原版内嵌版本记录：`067bd4c8825c495ca8777b433bd132f36ab39d28`

## 修改内容

- 新增 `KeiMiPersistentClock`，拦截 `TextView.setText(CharSequence, BufferType)`。
- 只处理原功能确认的主屏状态栏时钟对象；功能关闭时放行。
- 将系统写入的时间与缓存电池信息组合成双行内容，保留功率、温度、秒钟及隐藏单位选项。
- 在 `xg4` 的渲染和恢复方法中增加重入标记，并保证异常退出时清理。
- 在 `ep4` 注册 Hook，在 `ug4` 将其纳入原有生命周期回收。

本补丁不会强制显示系统隐藏的整个状态栏。布局变化和其它模块冲突仍需设备测试。

## 构建

需要 Python 3、Java、Apktool 2.12.1，以及提供 `zipalign` / `apksigner` 的 Android SDK Build Tools。以下命令使用类 Unix shell；Windows 可通过对应工具的等效命令执行。

1. 将上述原版 APK 放到 `upload/`，核对 SHA-256。每次构建从未打补丁的原版重新解码；脚本不能重复应用。
2. 在仓库根目录创建构建目录并解码，不解码资源：

```sh
mkdir -p inspect output patch/modified
java -jar tooling/apktool.jar d --no-res -f 'upload/KeiMi_2.5.0+067bd4c8.apk' -o inspect/keimi
python3 patch/apply.py
java -jar tooling/apktool.jar b -f -api 35 inspect/keimi -o output/keimi-unsigned.apk
zipalign -P 16 -f 4 output/keimi-unsigned.apk output/keimi-aligned.apk
```

3. 使用自己保管的签名密钥签名；密钥和密码文件应存放在仓库之外：

```sh
apksigner sign --ks /path/to/private-keystore.jks --ks-key-alias YOUR_ALIAS --ks-pass file:/path/to/private-password.txt --out output/KeiMi_PersistentClock.apk output/keimi-aligned.apk
apksigner verify --verbose --print-certs output/KeiMi_PersistentClock.apk
zipalign -c -P 16 -v 4 output/KeiMi_PersistentClock.apk
```

`patch/apply.py` 会生成修改后的 `xg4.smali`、`ep4.smali`、`ug4.smali`，并复制新增 Hook。不要将私钥或密码上传至 GitHub。

## 安装与回退

使用自己的签名构建后，签名会与官方原版及之前的定制测试包不同，不能直接覆盖安装。先备份设置，再卸载已有版本，安装新包，在 Xposed 框架中重新启用模块并按原版要求设置作用域，然后重启。

建议检查：1 秒与 3 秒刷新、跨分钟、息屏亮屏、控制中心展开收起、充电插拔，以及关闭功能后能否恢复普通时钟。

如系统界面异常，禁用模块并重启。回退原版需卸载定制包、重新安装原版并恢复设置。

## 验证状态

此前测试包构建记录显示：APK 编译、v3 签名验证、16 KiB 对齐、ZIP 完整性和重新反汇编检查通过；清单、资源、原生库与其它非签名载荷保持原字节内容。该结果属于此前构建记录。

本次仓库整理从原修改记录恢复了新增 Hook 与补丁脚本，并检查了脚本语法及恢复内容。未重新构建 APK，未执行手机实测，也未测量功耗。不能据此保证所有机型上的闪烁或消失问题均已解决。

## 项目来源

KeiMi 的名称、原版应用及其原有代码归原作者所有。本仓库只记录这项定制修改；与原作者不存在官方关联。未获得完整上游源码或确认其开源许可证，因此不为上游代码另行指定许可证。
