.class public final LKeiMiPersistentClock;
.super Ljava/lang/Object;
.implements Lio/github/libxposed/api/XposedInterface$Hooker;

.field private final owner:Lxg4;

.method public constructor <init>(Lxg4;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, LKeiMiPersistentClock;->owner:Lxg4;
    return-void
.end method

.method public static install(Lsa2;Lxg4;)Lio/github/libxposed/api/XposedInterface$HookHandle;
    .locals 4
    const-class v0, Landroid/widget/TextView;
    const-class v1, Ljava/lang/CharSequence;
    const-class v2, Landroid/widget/TextView$BufferType;
    filled-new-array {v1, v2}, [Ljava/lang/Class;
    move-result-object v1
    const-string v2, "setText"
    invoke-virtual {v0, v2, v1}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v0
    new-instance v1, LKeiMiPersistentClock;
    invoke-direct {v1, p1}, LKeiMiPersistentClock;-><init>(Lxg4;)V
    const-string v2, "keimi.systemui.statusbar-clock-persistent-text"
    invoke-virtual {p0, v0, v2, v1}, Lsa2;->O(Ljava/lang/reflect/Executable;Ljava/lang/String;Lio/github/libxposed/api/XposedInterface$Hooker;)Lio/github/libxposed/api/XposedInterface$HookHandle;
    move-result-object v3
    return-object v3
.end method

.method public final intercept(Lio/github/libxposed/api/XposedInterface$Chain;)Ljava/lang/Object;
    .locals 11
    iget-object v0, p0, LKeiMiPersistentClock;->owner:Lxg4;
    iget-boolean v1, v0, Lxg4;->persistentWriting:Z
    if-nez v1, :original
    iget-object v1, v0, Lxg4;->I0:Ljava/lang/ref/WeakReference;
    if-eqz v1, :original
    invoke-virtual {v1}, Ljava/lang/ref/Reference;->get()Ljava/lang/Object;
    move-result-object v1
    invoke-interface {p1}, Lio/github/libxposed/api/XposedInterface$Chain;->getThisObject()Ljava/lang/Object;
    move-result-object v2
    if-ne v1, v2, :original
    if-eqz v2, :original
    invoke-virtual {v0}, Lxg4;->o()Z
    move-result v1
    if-eqz v1, :original
    const/4 v1, 0x0
    invoke-interface {p1, v1}, Lio/github/libxposed/api/XposedInterface$Chain;->getArg(I)Ljava/lang/Object;
    move-result-object v3
    instance-of v4, v3, Ljava/lang/CharSequence;
    if-eqz v4, :original
    invoke-virtual {v3}, Ljava/lang/Object;->toString()Ljava/lang/String;
    move-result-object v3
    const-string v4, "\n"
    invoke-virtual {v3, v4}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v4
    if-nez v4, :original
    invoke-virtual {v3}, Ljava/lang/String;->trim()Ljava/lang/String;
    move-result-object v3
    invoke-virtual {v3}, Ljava/lang/String;->length()I
    move-result v4
    if-eqz v4, :original
    iget-object v4, v0, Lxg4;->I:Lsk1;
    invoke-virtual {v4}, Lsk1;->I()Ljava/lang/Object;
    move-result-object v4
    check-cast v4, Lc41;
    iget-boolean v5, v4, Lc41;->loO:Z
    iget-boolean v6, v4, Lc41;->loo:Z
    or-int v7, v5, v6
    if-eqz v7, :original
    check-cast v2, Landroid/widget/TextView;
    const/4 v7, 0x1
    iput-boolean v7, v0, Lxg4;->persistentWriting:Z
    :prepare_start
    iput-object v3, v0, Lxg4;->I1:Ljava/lang/String;
    iget-boolean v8, v4, Lc41;->lol:Z
    if-eqz v8, :time_ready
    invoke-virtual {v2}, Landroid/view/View;->getContext()Landroid/content/Context;
    move-result-object v3
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J
    move-result-wide v8
    invoke-static {v3, v7, v8, v9}, Lbc2;->lO(Landroid/content/Context;ZJ)Ljava/lang/String;
    move-result-object v3
    :time_ready
    iget-boolean v4, v4, Lc41;->O00:Z
    iget-object v8, v0, Lxg4;->lO:Ltg4;
    invoke-static {v8, v5, v6, v4}, Lbc2;->ol(Ltg4;ZZZ)Ljava/lang/String;
    move-result-object v4
    and-int v5, v5, v6
    iget-object v6, v0, Lxg4;->lI:Lzg4;
    invoke-virtual {v2}, Landroid/widget/TextView;->getPaint()Landroid/text/TextPaint;
    move-result-object v8
    invoke-virtual {v6, v3, v4, v8, v5}, Lzg4;->I(Ljava/lang/String;Ljava/lang/String;Landroid/text/TextPaint;Z)Ljava/lang/CharSequence;
    move-result-object v3
    invoke-virtual {v2, v1}, Landroid/widget/TextView;->setSingleLine(Z)V
    const/4 v4, 0x2
    invoke-virtual {v2, v4}, Landroid/widget/TextView;->setMaxLines(I)V
    invoke-virtual {v2, v1}, Landroid/widget/TextView;->setHorizontallyScrolling(Z)V
    const/4 v5, 0x0
    const v6, 0x3f570a3d
    invoke-virtual {v2, v5, v6}, Landroid/widget/TextView;->setLineSpacing(FF)V
    invoke-interface {p1}, Lio/github/libxposed/api/XposedInterface$Chain;->getArgs()Ljava/util/List;
    move-result-object v2
    invoke-interface {v2}, Ljava/util/List;->toArray()[Ljava/lang/Object;
    move-result-object v2
    aput-object v3, v2, v1
    iput-object v3, v0, Lxg4;->ll:Ljava/lang/CharSequence;
    :prepare_end
    .catchall {:prepare_start .. :prepare_end} :prepare_failed
    :proceed_start
    invoke-interface {p1, v2}, Lio/github/libxposed/api/XposedInterface$Chain;->proceed([Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v2
    :proceed_end
    .catchall {:proceed_start .. :proceed_end} :proceed_failed
    iput-boolean v1, v0, Lxg4;->persistentWriting:Z
    return-object v2
    :proceed_failed
    move-exception v2
    iput-boolean v1, v0, Lxg4;->persistentWriting:Z
    throw v2
    :prepare_failed
    move-exception v2
    iput-boolean v1, v0, Lxg4;->persistentWriting:Z
    :original
    invoke-interface {p1}, Lio/github/libxposed/api/XposedInterface$Chain;->proceed()Ljava/lang/Object;
    move-result-object v0
    return-object v0
.end method
