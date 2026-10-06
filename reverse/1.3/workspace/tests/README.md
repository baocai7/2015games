# 逆向代码检查

建议每次修改后至少执行：

```sh
find ../lua/decompiled/src -type f -name '*.lua' | wc -l
rg -n 'setLogicURL|dungeonInit|mainfightresult|summon|lottery|payment' ../lua/decompiled/src
rg -n 'Armature:create|addSpriteFrames|load.*plist|load.*json' ../lua/decompiled/src/app
```

重点记录接口返回、资源路径、异步回调次数、场景切换次数和异常堆栈。完整调用点清单在 `../../analysis/`。
