.class public Lcn/uc/gamesdk/c/a;
.super Ljava/lang/Object;


# static fields
.field private static final a:Ljava/lang/String; = "SdkPreference"

.field private static final b:Ljava/lang/String; = "cn.uc.gamesdk.rex.lastupdatetime"

.field private static final c:Ljava/lang/String; = "cn.uc.gamesdk.rex.isdownloading"

.field private static final d:Ljava/lang/String; = "cn.uc.gamesdk.pref"

.field private static final e:Ljava/lang/String; = "cn.uc.gamesdk.cmcc.pay.loginresult"

.field private static final f:Ljava/lang/String; = "cn.uc.gamesdk.cmcc.download.authentication.time"

.field private static final g:Ljava/lang/String; = "cn.uc.gamesdk.si"

.field private static final h:Ljava/lang/String; = "cn.uc.gamesdk.appcachepolicy"

.field private static final i:Ljava/lang/String; = "cn.uc.gamesdk.lastrexprojdirsize"

.field private static final j:Ljava/lang/String; = "cn.uc.gamesdk.useraccounttype"

.field private static final k:Ljava/lang/String; = "cn.uc.gamesdk.rexDefaultPackageLastPackTime"

.field private static final l:Ljava/lang/String; = "cn.uc.gamesdk.rexconfigoption"

.field private static final m:Ljava/lang/String; = "cn.uc.gamesdk.orient"

.field private static final n:Ljava/lang/String; = "cn.uc.gamesdk.channelid"

.field private static final o:Ljava/lang/String; = "cn.uc.gamesdk.setting.packfile.md5"

.field private static final p:Ljava/lang/String; = "cn.uc.gamesdk.lastLoginUCAccount"

.field private static final q:Ljava/lang/String; = "cn.uc.gamesdk.lastLoginGameAccount"

.field private static final r:Ljava/lang/String; = "cn.uc.gamesdk.autoLoginState"

.field private static final s:Ljava/lang/String; = "cn.uc.gamesdk.forceShowLogin"

.field private static final t:Ljava/lang/String; = "cn.uc.gamesdk.systemConfigFile.md5"

.field private static final u:Ljava/lang/String; = "cn.uc.gamesdk.verifyCode"

.field private static final v:Ljava/lang/String; = "cn.uc.gamesdk.resetui"

.field private static final w:Ljava/lang/String; = "cn.uc.gamesdk.rexProj"

.field private static x:Landroid/content/SharedPreferences;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    const/4 v0, 0x0

    sput-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static declared-synchronized a(I)V
    .locals 3

    const-class v1, Lcn/uc/gamesdk/c/a;

    monitor-enter v1

    :try_start_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v2, "cn.uc.gamesdk.useraccounttype"

    invoke-interface {v0, v2, p0}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v1

    return-void

    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0
.end method

.method public static declared-synchronized a(J)V
    .locals 3

    const-class v1, Lcn/uc/gamesdk/c/a;

    monitor-enter v1

    :try_start_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v2, "cn.uc.gamesdk.rex.lastupdatetime"

    invoke-interface {v0, v2, p0, p1}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v1

    return-void

    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0
.end method

.method public static declared-synchronized a(Ljava/lang/String;)V
    .locals 3

    const-class v1, Lcn/uc/gamesdk/c/a;

    monitor-enter v1

    :try_start_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v2, "cn.uc.gamesdk.rexDefaultPackageLastPackTime"

    invoke-interface {v0, v2, p0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v1

    return-void

    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0
.end method

.method public static declared-synchronized a(Z)V
    .locals 3

    const-class v1, Lcn/uc/gamesdk/c/a;

    monitor-enter v1

    :try_start_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v2, "cn.uc.gamesdk.rex.isdownloading"

    invoke-interface {v0, v2, p0}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v1

    return-void

    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0
.end method

.method public static a()Z
    .locals 3

    const/4 v0, 0x0

    sget-object v1, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v1, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v1, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-eqz v1, :cond_1

    sget-object v1, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    const-string v2, "cn.uc.gamesdk.rex.isdownloading"

    invoke-interface {v1, v2, v0}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    :cond_1
    return v0
.end method

.method public static b()Ljava/lang/String;
    .locals 3

    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-eqz v0, :cond_1

    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    const-string v1, "cn.uc.gamesdk.rexDefaultPackageLastPackTime"

    const-string v2, ""

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :goto_0
    return-object v0

    :cond_1
    const/4 v0, 0x0

    goto :goto_0
.end method

.method public static b(I)V
    .locals 2

    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "cn.uc.gamesdk.appcachepolicy"

    invoke-interface {v0, v1, p0}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    return-void
.end method

.method public static declared-synchronized b(J)V
    .locals 3

    const-class v1, Lcn/uc/gamesdk/c/a;

    monitor-enter v1

    :try_start_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v2, "cn.uc.gamesdk.cmcc.download.authentication.time"

    invoke-interface {v0, v2, p0, p1}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v1

    return-void

    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0
.end method

.method public static declared-synchronized b(Ljava/lang/String;)V
    .locals 3

    const-class v1, Lcn/uc/gamesdk/c/a;

    monitor-enter v1

    :try_start_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v2, "cn.uc.gamesdk.cmcc.pay.loginresult"

    invoke-interface {v0, v2, p0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v1

    return-void

    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0
.end method

.method public static declared-synchronized b(Z)V
    .locals 3

    const-class v1, Lcn/uc/gamesdk/c/a;

    monitor-enter v1

    :try_start_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v2, "cn.uc.gamesdk.autoLoginState"

    invoke-interface {v0, v2, p0}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v1

    return-void

    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0
.end method

.method public static c()J
    .locals 4

    const-wide/16 v0, 0x0

    sget-object v2, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v2, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v2, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-eqz v2, :cond_1

    sget-object v2, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    const-string v3, "cn.uc.gamesdk.rex.lastupdatetime"

    invoke-interface {v2, v3, v0, v1}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J

    move-result-wide v0

    :cond_1
    return-wide v0
.end method

.method public static declared-synchronized c(I)V
    .locals 3

    const-class v1, Lcn/uc/gamesdk/c/a;

    monitor-enter v1

    :try_start_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v2, "cn.uc.gamesdk.resetui"

    invoke-interface {v0, v2, p0}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v1

    return-void

    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0
.end method

.method public static c(J)V
    .locals 2

    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "cn.uc.gamesdk.lastrexprojdirsize"

    invoke-interface {v0, v1, p0, p1}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    return-void
.end method

.method public static declared-synchronized c(Ljava/lang/String;)V
    .locals 3

    const-class v1, Lcn/uc/gamesdk/c/a;

    monitor-enter v1

    :try_start_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v2, "cn.uc.gamesdk.si"

    invoke-interface {v0, v2, p0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v1

    return-void

    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0
.end method

.method public static declared-synchronized c(Z)V
    .locals 3

    const-class v1, Lcn/uc/gamesdk/c/a;

    monitor-enter v1

    :try_start_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v2, "cn.uc.gamesdk.forceShowLogin"

    invoke-interface {v0, v2, p0}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v1

    return-void

    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0
.end method

.method public static d()Landroid/content/SharedPreferences$Editor;
    .locals 1

    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    const/4 v0, 0x0

    :goto_0
    return-object v0

    :cond_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    goto :goto_0
.end method

.method public static declared-synchronized d(Ljava/lang/String;)V
    .locals 3

    const-class v1, Lcn/uc/gamesdk/c/a;

    monitor-enter v1

    :try_start_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v2, "cn.uc.gamesdk.channelid"

    invoke-interface {v0, v2, p0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v1

    return-void

    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0
.end method

.method public static e()J
    .locals 4

    const-wide/16 v0, 0x0

    sget-object v2, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v2, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v2, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-eqz v2, :cond_1

    sget-object v2, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    const-string v3, "cn.uc.gamesdk.cmcc.download.authentication.time"

    invoke-interface {v2, v3, v0, v1}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J

    move-result-wide v0

    :cond_1
    return-wide v0
.end method

.method public static declared-synchronized e(Ljava/lang/String;)V
    .locals 3

    const-class v1, Lcn/uc/gamesdk/c/a;

    monitor-enter v1

    :try_start_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v2, "cn.uc.gamesdk.rexconfigoption"

    invoke-interface {v0, v2, p0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v1

    return-void

    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0
.end method

.method public static f()Ljava/lang/String;
    .locals 3

    const/4 v0, 0x0

    sget-object v1, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v1, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v1, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-eqz v1, :cond_1

    sget-object v1, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    const-string v2, "cn.uc.gamesdk.cmcc.pay.loginresult"

    invoke-interface {v1, v2, v0}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :cond_1
    return-object v0
.end method

.method public static f(Ljava/lang/String;)V
    .locals 2

    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "cn.uc.gamesdk.orient"

    invoke-interface {v0, v1, p0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    return-void
.end method

.method public static declared-synchronized g(Ljava/lang/String;)V
    .locals 3

    const-class v1, Lcn/uc/gamesdk/c/a;

    monitor-enter v1

    :try_start_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v2, "cn.uc.gamesdk.setting.packfile.md5"

    invoke-interface {v0, v2, p0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v1

    return-void

    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0
.end method

.method public static g()Z
    .locals 1

    invoke-static {}, Lcn/uc/gamesdk/c/a;->h()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcn/uc/gamesdk/d/f;->d(Ljava/lang/String;)Z

    move-result v0

    return v0
.end method

.method public static h()Ljava/lang/String;
    .locals 3

    const/4 v0, 0x0

    sget-object v1, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v1, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v1, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-eqz v1, :cond_1

    sget-object v1, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    const-string v2, "cn.uc.gamesdk.si"

    invoke-interface {v1, v2, v0}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :cond_1
    return-object v0
.end method

.method public static declared-synchronized h(Ljava/lang/String;)V
    .locals 3

    const-class v1, Lcn/uc/gamesdk/c/a;

    monitor-enter v1

    :try_start_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v2, "cn.uc.gamesdk.lastLoginUCAccount"

    invoke-interface {v0, v2, p0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v1

    return-void

    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0
.end method

.method public static i()I
    .locals 3

    const/4 v0, 0x0

    sget-object v1, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v1, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v1, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-eqz v1, :cond_1

    sget-object v1, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    const-string v2, "cn.uc.gamesdk.appcachepolicy"

    invoke-interface {v1, v2, v0}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v0

    :cond_1
    return v0
.end method

.method public static declared-synchronized i(Ljava/lang/String;)V
    .locals 3

    const-class v1, Lcn/uc/gamesdk/c/a;

    monitor-enter v1

    :try_start_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v2, "cn.uc.gamesdk.lastLoginGameAccount"

    invoke-interface {v0, v2, p0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v1

    return-void

    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0
.end method

.method public static j()J
    .locals 4

    const-wide/16 v0, 0x0

    sget-object v2, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v2, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v2, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-eqz v2, :cond_1

    sget-object v2, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    const-string v3, "cn.uc.gamesdk.lastrexprojdirsize"

    invoke-interface {v2, v3, v0, v1}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J

    move-result-wide v0

    :cond_1
    return-wide v0
.end method

.method public static declared-synchronized j(Ljava/lang/String;)V
    .locals 3

    const-class v1, Lcn/uc/gamesdk/c/a;

    monitor-enter v1

    :try_start_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v2, "cn.uc.gamesdk.systemConfigFile.md5"

    invoke-interface {v0, v2, p0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v1

    return-void

    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0
.end method

.method public static declared-synchronized k(Ljava/lang/String;)V
    .locals 3

    const-class v1, Lcn/uc/gamesdk/c/a;

    monitor-enter v1

    :try_start_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v2, "cn.uc.gamesdk.verifyCode"

    invoke-interface {v0, v2, p0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v1

    return-void

    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0
.end method

.method public static k()Z
    .locals 2

    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-eqz v0, :cond_1

    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    const-string v1, "cn.uc.gamesdk.lastrexprojdirsize"

    invoke-interface {v0, v1}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v0

    :goto_0
    return v0

    :cond_1
    const/4 v0, 0x0

    goto :goto_0
.end method

.method public static l()Ljava/lang/String;
    .locals 3

    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-eqz v0, :cond_1

    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    const-string v1, "cn.uc.gamesdk.channelid"

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :goto_0
    return-object v0

    :cond_1
    const-string v0, ""

    goto :goto_0
.end method

.method public static declared-synchronized l(Ljava/lang/String;)V
    .locals 3

    const-class v1, Lcn/uc/gamesdk/c/a;

    monitor-enter v1

    :try_start_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v2, "cn.uc.gamesdk.rexProj"

    invoke-interface {v0, v2, p0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v1

    return-void

    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0
.end method

.method public static m()Ljava/lang/String;
    .locals 3

    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-eqz v0, :cond_1

    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    const-string v1, "cn.uc.gamesdk.rexconfigoption"

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :goto_0
    return-object v0

    :cond_1
    const-string v0, ""

    goto :goto_0
.end method

.method public static n()Z
    .locals 2

    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-eqz v0, :cond_1

    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    const-string v1, "cn.uc.gamesdk.orient"

    invoke-interface {v0, v1}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v0

    :goto_0
    return v0

    :cond_1
    const/4 v0, 0x0

    goto :goto_0
.end method

.method public static o()Ljava/lang/String;
    .locals 4

    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-eqz v0, :cond_2

    sget-object v1, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    const-string v2, "cn.uc.gamesdk.orient"

    sget-object v0, Lcn/uc/gamesdk/a/d;->b:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object v0

    iget v0, v0, Landroid/content/res/Configuration;->orientation:I

    const/4 v3, 0x1

    if-ne v0, v3, :cond_1

    const-string v0, "P"

    :goto_0
    invoke-interface {v1, v2, v0}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :goto_1
    return-object v0

    :cond_1
    const-string v0, "L"

    goto :goto_0

    :cond_2
    const-string v0, "P"

    goto :goto_1
.end method

.method public static p()Ljava/lang/String;
    .locals 3

    const/4 v0, 0x0

    sget-object v1, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v1, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v1, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-eqz v1, :cond_1

    sget-object v1, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    const-string v2, "cn.uc.gamesdk.setting.packfile.md5"

    invoke-interface {v1, v2, v0}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :cond_1
    return-object v0
.end method

.method public static q()Ljava/lang/String;
    .locals 3

    const/4 v0, 0x0

    sget-object v1, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v1, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v1, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-eqz v1, :cond_1

    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    const-string v1, "cn.uc.gamesdk.lastLoginUCAccount"

    const-string v2, ""

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :cond_1
    return-object v0
.end method

.method public static r()Ljava/lang/String;
    .locals 3

    const/4 v0, 0x0

    sget-object v1, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v1, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v1, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-eqz v1, :cond_1

    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    const-string v1, "cn.uc.gamesdk.lastLoginGameAccount"

    const-string v2, ""

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :cond_1
    return-object v0
.end method

.method public static s()Z
    .locals 3

    const/4 v0, 0x1

    sget-object v1, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v1, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v1, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-eqz v1, :cond_1

    sget-object v1, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    const-string v2, "cn.uc.gamesdk.autoLoginState"

    invoke-interface {v1, v2, v0}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    :cond_1
    return v0
.end method

.method public static t()Z
    .locals 3

    const/4 v0, 0x0

    sget-object v1, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v1, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v1, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-eqz v1, :cond_1

    sget-object v1, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    const-string v2, "cn.uc.gamesdk.forceShowLogin"

    invoke-interface {v1, v2, v0}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    :cond_1
    return v0
.end method

.method public static u()Ljava/lang/String;
    .locals 3

    const/4 v0, 0x0

    sget-object v1, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v1, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v1, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-eqz v1, :cond_1

    sget-object v1, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    const-string v2, "cn.uc.gamesdk.systemConfigFile.md5"

    invoke-interface {v1, v2, v0}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :cond_1
    return-object v0
.end method

.method public static v()Ljava/lang/String;
    .locals 3

    const/4 v0, 0x0

    sget-object v1, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v1, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v1, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-eqz v1, :cond_1

    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    const-string v1, "cn.uc.gamesdk.verifyCode"

    const-string v2, ""

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :cond_1
    return-object v0
.end method

.method public static w()I
    .locals 3

    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    const-string v1, "cn.uc.gamesdk.resetui"

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v0

    return v0
.end method

.method public static x()Ljava/lang/String;
    .locals 3

    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/c/a;->y()V

    :cond_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    const-string v1, "cn.uc.gamesdk.rexProj"

    const-string v2, ""

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method private static declared-synchronized y()V
    .locals 4

    const-class v1, Lcn/uc/gamesdk/c/a;

    monitor-enter v1

    :try_start_0
    sget-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/a/e;->b()Landroid/content/Context;

    move-result-object v0

    if-eqz v0, :cond_0

    invoke-static {}, Lcn/uc/gamesdk/a/e;->b()Landroid/content/Context;

    move-result-object v0

    const-string v2, "cn.uc.gamesdk.pref"

    const/4 v3, 0x3

    invoke-virtual {v0, v2, v3}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    sput-object v0, Lcn/uc/gamesdk/c/a;->x:Landroid/content/SharedPreferences;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    :cond_0
    monitor-exit v1

    return-void

    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0
.end method
