# 修改补丁目录

每项修改建立独立子目录，例如 `patches/stage-load-guard/`，至少包含：

- `README.md`：问题、根因、涉及文件、验证步骤；
- `diff.patch`：相对于 `../lua/decompiled/` 的最小改动；
- `test-log.txt`：设备或模拟器实测结果。

当前目录只保存修改记录，不覆盖原始反编译代码。

