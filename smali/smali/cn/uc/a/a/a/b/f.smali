.class public Lcn/uc/a/a/a/b/f;
.super Ljava/lang/Object;


# static fields
.field public static final a:Ljava/lang/String; = "cn.uc.gamesdk.si"

.field private static b:Ljava/lang/String; = null

.field private static c:Landroid/content/SharedPreferences; = null

.field private static final d:Ljava/lang/String; = "cn.uc.gamesdk.random.pref"

.field private static final e:Ljava/lang/String; = "ci"


# direct methods
.method static constructor <clinit>()V
    .locals 1

    const-string v0, "PreferenceUtil"

    sput-object v0, Lcn/uc/a/a/a/b/f;->b:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static a(Ljava/lang/String;)I
    .locals 2

    sget-object v0, Lcn/uc/a/a/a/b/f;->c:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/a/a/a/b/f;->a()V

    :cond_0
    sget-object v0, Lcn/uc/a/a/a/b/f;->c:Landroid/content/SharedPreferences;

    if-eqz v0, :cond_1

    sget-object v0, Lcn/uc/a/a/a/b/f;->c:Landroid/content/SharedPreferences;

    const/4 v1, 0x0

    invoke-interface {v0, p0, v1}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v0

    :goto_0
    return v0

    :cond_1
    const/4 v0, -0x1

    goto :goto_0
.end method

.method private static declared-synchronized a()V
    .locals 4

    const-class v1, Lcn/uc/a/a/a/b/f;

    monitor-enter v1

    :try_start_0
    sget-object v0, Lcn/uc/a/a/a/b/f;->c:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/a/a/a/a;->a()Landroid/content/Context;

    move-result-object v0

    if-eqz v0, :cond_0

    invoke-static {}, Lcn/uc/a/a/a/a;->a()Landroid/content/Context;

    move-result-object v0

    const-string v2, "cn.uc.gamesdk.random.pref"

    const/4 v3, 0x3

    invoke-virtual {v0, v2, v3}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    sput-object v0, Lcn/uc/a/a/a/b/f;->c:Landroid/content/SharedPreferences;
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

.method public static declared-synchronized a(Ljava/lang/String;I)V
    .locals 2

    const-class v1, Lcn/uc/a/a/a/b/f;

    monitor-enter v1

    :try_start_0
    sget-object v0, Lcn/uc/a/a/a/b/f;->c:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/a/a/a/b/f;->a()V

    :cond_0
    sget-object v0, Lcn/uc/a/a/a/b/f;->c:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0, p0, p1}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

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

.method public static declared-synchronized a(Ljava/lang/String;Ljava/lang/Boolean;)V
    .locals 3

    const-class v1, Lcn/uc/a/a/a/b/f;

    monitor-enter v1

    :try_start_0
    sget-object v0, Lcn/uc/a/a/a/b/f;->c:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/a/a/a/b/f;->a()V

    :cond_0
    sget-object v0, Lcn/uc/a/a/a/b/f;->c:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-virtual {p1}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v2

    invoke-interface {v0, p0, v2}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

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

.method public static declared-synchronized a(Ljava/lang/String;Ljava/lang/String;)V
    .locals 2

    const-class v1, Lcn/uc/a/a/a/b/f;

    monitor-enter v1

    :try_start_0
    sget-object v0, Lcn/uc/a/a/a/b/f;->c:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/a/a/a/b/f;->a()V

    :cond_0
    sget-object v0, Lcn/uc/a/a/a/b/f;->c:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0, p0, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

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

.method public static declared-synchronized a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 4

    const-class v1, Lcn/uc/a/a/a/b/f;

    monitor-enter v1

    :try_start_0
    invoke-static {}, Lcn/uc/a/a/a/a;->a()Landroid/content/Context;

    move-result-object v0

    if-eqz v0, :cond_1

    invoke-static {}, Lcn/uc/a/a/a/a;->a()Landroid/content/Context;

    move-result-object v0

    const/4 v2, 0x3

    invoke-virtual {v0, p0, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    if-eqz v0, :cond_0

    sget-object v0, Lcn/uc/a/a/a/b/f;->c:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0, p1, p2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    :goto_0
    monitor-exit v1

    return-void

    :cond_0
    :try_start_1
    sget-object v0, Lcn/uc/a/a/a/b/f;->b:Ljava/lang/String;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "SharedPreferences: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " is null!"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v2}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_0

    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0

    :cond_1
    :try_start_2
    sget-object v0, Lcn/uc/a/a/a/b/f;->b:Ljava/lang/String;

    const-string v2, "ApplicationContext is null!"

    invoke-static {v0, v2}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    goto :goto_0
.end method

.method public static b(Ljava/lang/String;)Ljava/lang/String;
    .locals 2

    sget-object v0, Lcn/uc/a/a/a/b/f;->c:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/a/a/a/b/f;->a()V

    :cond_0
    sget-object v0, Lcn/uc/a/a/a/b/f;->c:Landroid/content/SharedPreferences;

    if-eqz v0, :cond_1

    sget-object v0, Lcn/uc/a/a/a/b/f;->c:Landroid/content/SharedPreferences;

    const-string v1, ""

    invoke-interface {v0, p0, v1}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :goto_0
    return-object v0

    :cond_1
    const-string v0, ""

    goto :goto_0
.end method

.method public static b(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 2

    invoke-static {}, Lcn/uc/a/a/a/a;->a()Landroid/content/Context;

    move-result-object v0

    if-eqz v0, :cond_1

    invoke-static {}, Lcn/uc/a/a/a/a;->a()Landroid/content/Context;

    move-result-object v0

    const/4 v1, 0x3

    invoke-virtual {v0, p0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    if-eqz v0, :cond_0

    const-string v1, ""

    invoke-interface {v0, p1, v1}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :goto_0
    return-object v0

    :cond_0
    const-string v0, ""

    goto :goto_0

    :cond_1
    const-string v0, ""

    goto :goto_0
.end method

.method public static c(Ljava/lang/String;)Ljava/lang/Boolean;
    .locals 2

    const/4 v1, 0x0

    sget-object v0, Lcn/uc/a/a/a/b/f;->c:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    invoke-static {}, Lcn/uc/a/a/a/b/f;->a()V

    :cond_0
    sget-object v0, Lcn/uc/a/a/a/b/f;->c:Landroid/content/SharedPreferences;

    if-eqz v0, :cond_1

    sget-object v0, Lcn/uc/a/a/a/b/f;->c:Landroid/content/SharedPreferences;

    invoke-interface {v0, p0, v1}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    invoke-static {v0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v0

    :goto_0
    return-object v0

    :cond_1
    invoke-static {v1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v0

    goto :goto_0
.end method
