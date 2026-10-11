from pathlib import Path
root=Path('inspect/keimi/smali')
p=root/'xg4.smali'
s=p.read_text()
s=s.replace('# instance fields','# instance fields\n.field public persistentWriting:Z',1)
for name,args,new in [('I','Landroid/widget/TextView;Ltg4;','persistentRender'),('Io','Landroid/widget/TextView;','persistentRestore')]:
 signature=f'.method public final {name}({args})V'
 assert s.count(signature)==1
 s=s.replace(signature,f'.method public final {new}({args})V',1)
 registers='{p0, p1, p2}' if name=='I' else '{p0, p1}'
 s+=f'''\n{signature}
    .locals 1
    const/4 v0, 0x1
    iput-boolean v0, p0, Lxg4;->persistentWriting:Z
    :try_start
    invoke-virtual {registers}, Lxg4;->{new}({args})V
    :try_end
    .catchall {{:try_start .. :try_end}} :cleanup
    const/4 v0, 0x0
    iput-boolean v0, p0, Lxg4;->persistentWriting:Z
    return-void
    :cleanup
    move-exception v0
    const/4 v1, 0x0
    iput-boolean v1, p0, Lxg4;->persistentWriting:Z
    throw v0
.end method
'''.replace('.locals 1','.locals 2')
p.write_text(s)
p=root/'ep4.smali';s=p.read_text()
a='    filled-new-array {v3, v4, v1}, [Lio/github/libxposed/api/XposedInterface$HookHandle;'
assert s.count(a)==1
s=s.replace(a,'''    invoke-static {v2, v0}, LKeiMiPersistentClock;->install(Lsa2;Lxg4;)Lio/github/libxposed/api/XposedInterface$HookHandle;
    move-result-object v5
    filled-new-array {v3, v4, v1, v5}, [Lio/github/libxposed/api/XposedInterface$HookHandle;''')
p.write_text(s)
p=root/'ug4.smali';s=p.read_text()
s=s.replace('.locals 3','.locals 4',1)
s=s.replace('    filled-new-array {v2, v0, v1}, [Ljava/lang/String;','''    const-string v3, "keimi.systemui.statusbar-clock-persistent-text"
    filled-new-array {v2, v0, v1, v3}, [Ljava/lang/String;''',1)
p.write_text(s)
for n in ['xg4','ep4','ug4']:
 (Path('patch/modified')/(n+'.smali')).write_bytes((root/(n+'.smali')).read_bytes())
(root/'KeiMiPersistentClock.smali').write_bytes(Path('patch/modified/KeiMiPersistentClock.smali').read_bytes())
