.class public Lcn/uc/a/a/a/k;
.super Ljava/lang/Object;


# static fields
.field public static final a:Ljava/lang/String; = "UCStat"

.field private static final b:Ljava/lang/String; = "ci"

.field private static final c:Ljava/lang/String; = "ucgamesdk"

.field private static final d:Ljava/lang/String; = "config.properties"

.field private static final e:Ljava/lang/String; = "ci:%s|csid:%s|sequence:%d|isfirst:%s"

.field private static f:Ljava/lang/String;

.field private static g:I

.field private static h:Z

.field private static i:Ljava/lang/String;

.field private static j:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    const-string v0, ""

    sput-object v0, Lcn/uc/a/a/a/k;->f:Ljava/lang/String;

    const/4 v0, 0x0

    sput v0, Lcn/uc/a/a/a/k;->g:I

    const/4 v0, 0x1

    sput-boolean v0, Lcn/uc/a/a/a/k;->h:Z

    const-string v0, ""

    sput-object v0, Lcn/uc/a/a/a/k;->i:Ljava/lang/String;

    const-string v0, ""

    sput-object v0, Lcn/uc/a/a/a/k;->j:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static a()V
    .locals 3

    const-string v0, "UCStat"

    const-string v1, "initUCStat"

    const-string v2, "\u521d\u59cb\u5316\u7edf\u8ba1\u65e5\u5fd7\u6253\u70b9\u8bbe\u7f6e"

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    invoke-static {}, Lcn/uc/a/a/a/k;->g()Ljava/lang/String;

    move-result-object v0

    const-string v1, "debug"

    invoke-static {v0, v1}, Lcn/uc/a/a/a/b/d;->d(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcn/uc/a/a/a/k;->j:Ljava/lang/String;

    invoke-static {}, Lcn/uc/a/a/a/k;->k()V

    invoke-static {}, Lcn/uc/a/a/a/k;->j()Ljava/lang/String;

    const-string v0, "cn.uc.gamesdk.pref"

    const-string v1, "cn.uc.gamesdk.si"

    invoke-static {v0, v1}, Lcn/uc/a/a/a/b/f;->b(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcn/uc/a/a/a/b/j;->c(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    invoke-static {v0}, Lcn/uc/a/a/a/k;->a(Z)V

    :goto_0
    return-void

    :cond_0
    const/4 v0, 0x0

    invoke-static {v0}, Lcn/uc/a/a/a/k;->a(Z)V

    goto :goto_0
.end method

.method public static a(Ljava/lang/String;)V
    .locals 2

    const-string v0, "true"

    sget-object v1, Lcn/uc/a/a/a/k;->j:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    const-string v0, "key_using_widget"

    invoke-static {v0}, Lcn/uc/a/a/a/a;->d(Ljava/lang/String;)Ljava/lang/Boolean;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-static {p0}, Lcn/uc/a/a/a/k;->b(Ljava/lang/String;)V

    :cond_0
    :goto_0
    return-void

    :cond_1
    const/4 v0, 0x0

    invoke-static {p0, v0}, Lcn/uc/a/a/a/k;->a(Ljava/lang/String;Z)V

    goto :goto_0
.end method

.method public static a(Ljava/lang/String;Lcn/uc/a/a/a/i$a;)V
    .locals 2

    const-string v0, "true"

    sget-object v1, Lcn/uc/a/a/a/k;->j:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    const-string v0, "key_using_widget"

    invoke-static {v0}, Lcn/uc/a/a/a/a;->d(Ljava/lang/String;)Ljava/lang/Boolean;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-static {p0, p1}, Lcn/uc/a/a/a/k;->b(Ljava/lang/String;Lcn/uc/a/a/a/i$a;)V

    :cond_0
    :goto_0
    return-void

    :cond_1
    const/4 v0, 0x0

    invoke-static {p0, p1, v0}, Lcn/uc/a/a/a/k;->a(Ljava/lang/String;Lcn/uc/a/a/a/i$a;Z)V

    goto :goto_0
.end method

.method public static a(Ljava/lang/String;Lcn/uc/a/a/a/i$a;Z)V
    .locals 1

    const-string v0, "key_open_behaviors_logs"

    invoke-static {v0}, Lcn/uc/a/a/a/a;->d(Ljava/lang/String;)Ljava/lang/Boolean;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v0, "key_using_widget"

    invoke-static {v0}, Lcn/uc/a/a/a/a;->d(Ljava/lang/String;)Ljava/lang/Boolean;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0

    if-nez v0, :cond_1

    :cond_0
    if-eqz p2, :cond_2

    :cond_1
    invoke-static {p0, p1}, Lcn/uc/a/a/a/k;->b(Ljava/lang/String;Lcn/uc/a/a/a/i$a;)V

    :cond_2
    return-void
.end method

.method static synthetic a(Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    invoke-static {p0, p1}, Lcn/uc/a/a/a/k;->b(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method static synthetic a(Ljava/lang/String;Ljava/lang/String;Lcn/uc/a/a/a/i$a;)V
    .locals 0

    invoke-static {p0, p1, p2}, Lcn/uc/a/a/a/k;->b(Ljava/lang/String;Ljava/lang/String;Lcn/uc/a/a/a/i$a;)V

    return-void
.end method

.method public static a(Ljava/lang/String;Z)V
    .locals 1

    const-string v0, "key_open_behaviors_logs"

    invoke-static {v0}, Lcn/uc/a/a/a/a;->d(Ljava/lang/String;)Ljava/lang/Boolean;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v0, "key_using_widget"

    invoke-static {v0}, Lcn/uc/a/a/a/a;->d(Ljava/lang/String;)Ljava/lang/Boolean;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0

    if-nez v0, :cond_1

    :cond_0
    if-eqz p1, :cond_2

    :cond_1
    invoke-static {p0}, Lcn/uc/a/a/a/k;->b(Ljava/lang/String;)V

    :cond_2
    return-void
.end method

.method private static declared-synchronized a(Z)V
    .locals 2

    const-class v0, Lcn/uc/a/a/a/k;

    monitor-enter v0

    :try_start_0
    sput-boolean p0, Lcn/uc/a/a/a/k;->h:Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v0

    return-void

    :catchall_0
    move-exception v1

    monitor-exit v0

    throw v1
.end method

.method static synthetic b()Ljava/lang/String;
    .locals 1

    invoke-static {}, Lcn/uc/a/a/a/k;->j()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method private static b(Ljava/lang/String;)V
    .locals 2

    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcn/uc/a/a/a/k$2;

    invoke-direct {v1, p0}, Lcn/uc/a/a/a/k$2;-><init>(Ljava/lang/String;)V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method

.method private static b(Ljava/lang/String;Lcn/uc/a/a/a/i$a;)V
    .locals 2

    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcn/uc/a/a/a/k$1;

    invoke-direct {v1, p0, p1}, Lcn/uc/a/a/a/k$1;-><init>(Ljava/lang/String;Lcn/uc/a/a/a/i$a;)V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method

.method private static b(Ljava/lang/String;Ljava/lang/String;)V
    .locals 2

    const/4 v1, 0x1

    const-string v0, "enter"

    invoke-static {p0, v0, p1, v1}, Lcn/uc/a/a/a/i;->b(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)V

    const-string v0, "S"

    invoke-static {p0, v0, p1, v1}, Lcn/uc/a/a/a/i;->b(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)V

    return-void
.end method

.method private static b(Ljava/lang/String;Ljava/lang/String;Lcn/uc/a/a/a/i$a;)V
    .locals 1

    const-string v0, "enter"

    invoke-static {p0, v0, p1, p2}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcn/uc/a/a/a/i$a;)V

    const-string v0, "S"

    invoke-static {p0, v0, p1, p2}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcn/uc/a/a/a/i$a;)V

    return-void
.end method

.method static synthetic c()Ljava/lang/String;
    .locals 1

    invoke-static {}, Lcn/uc/a/a/a/k;->l()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method static synthetic d()I
    .locals 1

    invoke-static {}, Lcn/uc/a/a/a/k;->m()I

    move-result v0

    return v0
.end method

.method static synthetic e()Z
    .locals 1

    invoke-static {}, Lcn/uc/a/a/a/k;->n()Z

    move-result v0

    return v0
.end method

.method static synthetic f()Ljava/lang/String;
    .locals 1

    sget-object v0, Lcn/uc/a/a/a/k;->j:Ljava/lang/String;

    return-object v0
.end method

.method private static g()Ljava/lang/String;
    .locals 3

    const-string v0, "key_gameId"

    invoke-static {v0}, Lcn/uc/a/a/a/a;->b(Ljava/lang/String;)I

    move-result v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {}, Lcn/uc/a/a/a/k;->h()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    sget-object v2, Ljava/io/File;->separator:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "ucgamesdk"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    sget-object v2, Ljava/io/File;->separator:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    sget-object v1, Ljava/io/File;->separator:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "config.properties"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method private static h()Ljava/lang/String;
    .locals 3

    invoke-static {}, Landroid/os/Environment;->getExternalStorageDirectory()Ljava/io/File;

    move-result-object v0

    invoke-static {}, Landroid/os/Environment;->getExternalStorageState()Ljava/lang/String;

    move-result-object v1

    const-string v2, "mounted"

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-virtual {v0}, Ljava/io/File;->canWrite()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-virtual {v0}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v0

    :goto_0
    return-object v0

    :cond_0
    const-string v0, "/sdcard/"

    goto :goto_0
.end method

.method private static declared-synchronized i()Ljava/lang/String;
    .locals 6

    const-class v1, Lcn/uc/a/a/a/k;

    monitor-enter v1

    :try_start_0
    invoke-static {}, Ljava/util/UUID;->randomUUID()Ljava/util/UUID;

    move-result-object v0

    invoke-virtual {v0}, Ljava/util/UUID;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v2, "ci"

    invoke-static {v2, v0}, Lcn/uc/a/a/a/b/f;->a(Ljava/lang/String;Ljava/lang/String;)V

    invoke-static {}, Lcn/uc/a/a/a/k;->g()Ljava/lang/String;

    move-result-object v2

    const-string v3, "ci"

    invoke-static {v2, v3, v0}, Lcn/uc/a/a/a/b/d;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z

    const-string v2, "UCStat"

    const-string v3, "initCI"

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "ci = "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v2, v3, v4}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v1

    return-object v0

    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0
.end method

.method private static declared-synchronized j()Ljava/lang/String;
    .locals 5

    const-class v1, Lcn/uc/a/a/a/k;

    monitor-enter v1

    :try_start_0
    sget-object v0, Lcn/uc/a/a/a/k;->i:Ljava/lang/String;

    invoke-static {v0}, Lcn/uc/a/a/a/b/j;->c(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-static {}, Lcn/uc/a/a/a/k;->g()Ljava/lang/String;

    move-result-object v0

    const-string v2, "ci"

    invoke-static {v0, v2}, Lcn/uc/a/a/a/b/d;->d(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcn/uc/a/a/a/k;->i:Ljava/lang/String;

    sget-object v0, Lcn/uc/a/a/a/k;->i:Ljava/lang/String;

    invoke-static {v0}, Lcn/uc/a/a/a/b/j;->c(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v0, "ci"

    invoke-static {v0}, Lcn/uc/a/a/a/b/f;->b(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcn/uc/a/a/a/k;->i:Ljava/lang/String;

    sget-object v0, Lcn/uc/a/a/a/k;->i:Ljava/lang/String;

    invoke-static {v0}, Lcn/uc/a/a/a/b/j;->c(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-static {}, Lcn/uc/a/a/a/k;->i()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcn/uc/a/a/a/k;->i:Ljava/lang/String;

    :cond_0
    :goto_0
    const-string v0, "UCStat"

    const-string v2, "getCI"

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "ci = "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    sget-object v4, Lcn/uc/a/a/a/k;->i:Ljava/lang/String;

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v0, v2, v3}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    sget-object v0, Lcn/uc/a/a/a/k;->i:Ljava/lang/String;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v1

    return-object v0

    :cond_1
    :try_start_1
    invoke-static {}, Landroid/os/Environment;->getExternalStorageDirectory()Ljava/io/File;

    move-result-object v0

    invoke-static {}, Landroid/os/Environment;->getExternalStorageState()Ljava/lang/String;

    move-result-object v2

    const-string v3, "mounted"

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_0

    invoke-virtual {v0}, Ljava/io/File;->canWrite()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-static {}, Lcn/uc/a/a/a/k;->g()Ljava/lang/String;

    move-result-object v0

    const-string v2, "ci"

    sget-object v3, Lcn/uc/a/a/a/k;->i:Ljava/lang/String;

    invoke-static {v0, v2, v3}, Lcn/uc/a/a/a/b/d;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_0

    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0
.end method

.method private static declared-synchronized k()V
    .locals 2

    const-class v1, Lcn/uc/a/a/a/k;

    monitor-enter v1

    :try_start_0
    invoke-static {}, Ljava/util/UUID;->randomUUID()Ljava/util/UUID;

    move-result-object v0

    invoke-virtual {v0}, Ljava/util/UUID;->toString()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcn/uc/a/a/a/k;->f:Ljava/lang/String;

    const/4 v0, 0x0

    sput v0, Lcn/uc/a/a/a/k;->g:I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v1

    return-void

    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0
.end method

.method private static declared-synchronized l()Ljava/lang/String;
    .locals 2

    const-class v0, Lcn/uc/a/a/a/k;

    monitor-enter v0

    :try_start_0
    sget-object v1, Lcn/uc/a/a/a/k;->f:Ljava/lang/String;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v0

    return-object v1

    :catchall_0
    move-exception v1

    monitor-exit v0

    throw v1
.end method

.method private static declared-synchronized m()I
    .locals 2

    const-class v1, Lcn/uc/a/a/a/k;

    monitor-enter v1

    :try_start_0
    sget v0, Lcn/uc/a/a/a/k;->g:I

    add-int/lit8 v0, v0, 0x1

    sput v0, Lcn/uc/a/a/a/k;->g:I

    sget v0, Lcn/uc/a/a/a/k;->g:I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v1

    return v0

    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0
.end method

.method private static declared-synchronized n()Z
    .locals 2

    const-class v0, Lcn/uc/a/a/a/k;

    monitor-enter v0

    :try_start_0
    sget-boolean v1, Lcn/uc/a/a/a/k;->h:Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v0

    return v1

    :catchall_0
    move-exception v1

    monitor-exit v0

    throw v1
.end method
