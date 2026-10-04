.class public Lcn/uc/a/a/a/a/k;
.super Ljava/lang/Object;


# static fields
.field public static final a:Ljava/lang/String; = "proxy"

.field public static final b:Ljava/lang/String; = "update"

.field private static final c:Ljava/lang/String; = "."

.field private static final d:Ljava/lang/String; = "http://sdk.g.uc.cn/cs/data/si/"

.field private static final e:Ljava/lang/String; = "http://sdk.g.uc.cn/cs/data/host"

.field private static final f:Ljava/lang/String; = "http://"

.field private static final g:Ljava/lang/String; = "/cs/data/si/"

.field private static final h:Ljava/lang/String; = "/cs/data/host/"

.field private static final i:Ljava/lang/String; = "sdk.test4.g.uc.cn"

.field private static final j:Ljava/lang/String; = "http://sdk.test4.g.uc.cn/cs/data/si/"

.field private static final k:Ljava/lang/String; = "http://sdk.test4.g.uc.cn/cs/data/host/"

.field private static l:Ljava/lang/String;

.field private static m:Ljava/lang/String;

.field private static n:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    const/4 v0, 0x0

    sput-object v0, Lcn/uc/a/a/a/a/k;->l:Ljava/lang/String;

    sput-object v0, Lcn/uc/a/a/a/a/k;->m:Ljava/lang/String;

    const-string v0, "http://sdk.g.uc.cn/cs/msg/"

    sput-object v0, Lcn/uc/a/a/a/a/k;->n:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static a()Ljava/lang/String;
    .locals 1

    sget-boolean v0, Lcn/uc/a/a/a/a;->p:Z

    if-eqz v0, :cond_1

    sget-object v0, Lcn/uc/a/a/a/a/k;->l:Ljava/lang/String;

    invoke-static {v0}, Lcn/uc/a/a/a/b/j;->k(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v0, "http://sdk.test4.g.uc.cn/cs/data/si/"

    :goto_0
    return-object v0

    :cond_0
    sget-object v0, Lcn/uc/a/a/a/a/k;->l:Ljava/lang/String;

    goto :goto_0

    :cond_1
    const-string v0, "http://sdk.g.uc.cn/cs/data/si/"

    goto :goto_0
.end method

.method public static a(Ljava/lang/String;)V
    .locals 2

    invoke-static {p0}, Lcn/uc/a/a/a/b/j;->k(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_0

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "http://"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "/cs/data/si/"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcn/uc/a/a/a/a/k;->l:Ljava/lang/String;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "http://"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "/cs/data/host/"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcn/uc/a/a/a/a/k;->m:Ljava/lang/String;

    :cond_0
    return-void
.end method

.method public static declared-synchronized a(Ljava/lang/String;Ljava/lang/String;)V
    .locals 2

    const-class v1, Lcn/uc/a/a/a/a/k;

    monitor-enter v1

    :try_start_0
    sget-object v0, Lcn/uc/a/a/a/a;->a:Ljava/util/concurrent/ConcurrentHashMap;

    invoke-virtual {v0, p0, p1}, Ljava/util/concurrent/ConcurrentHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v1

    return-void

    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0
.end method

.method public static b()Ljava/lang/String;
    .locals 1

    sget-boolean v0, Lcn/uc/a/a/a/a;->p:Z

    if-eqz v0, :cond_1

    sget-object v0, Lcn/uc/a/a/a/a/k;->m:Ljava/lang/String;

    invoke-static {v0}, Lcn/uc/a/a/a/b/j;->k(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v0, "http://sdk.test4.g.uc.cn/cs/data/host/"

    :goto_0
    return-object v0

    :cond_0
    sget-object v0, Lcn/uc/a/a/a/a/k;->m:Ljava/lang/String;

    goto :goto_0

    :cond_1
    const-string v0, "http://sdk.g.uc.cn/cs/data/host"

    goto :goto_0
.end method

.method public static b(Ljava/lang/String;)Ljava/lang/String;
    .locals 2

    sget-object v0, Lcn/uc/a/a/a/a;->a:Ljava/util/concurrent/ConcurrentHashMap;

    invoke-virtual {v0, p0}, Ljava/util/concurrent/ConcurrentHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-static {v0}, Lcn/uc/a/a/a/b/j;->d(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_0

    :goto_0
    return-object v0

    :cond_0
    sget-boolean v0, Lcn/uc/a/a/a/a;->p:Z

    if-eqz v0, :cond_2

    sget-object v0, Lcn/uc/a/a/a/a/k;->m:Ljava/lang/String;

    invoke-static {v0}, Lcn/uc/a/a/a/b/j;->d(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_1

    sget-object v0, Lcn/uc/a/a/a/a/k;->m:Ljava/lang/String;

    goto :goto_0

    :cond_1
    const-string v0, "http://sdk.test4.g.uc.cn/cs/data/host/"

    goto :goto_0

    :cond_2
    const-string v0, "http://sdk.g.uc.cn/cs/data/host"

    goto :goto_0
.end method

.method public static c()Ljava/lang/String;
    .locals 3

    invoke-static {}, Lcn/uc/a/a/a/a/k;->b()Ljava/lang/String;

    move-result-object v0

    :try_start_0
    new-instance v1, Ljava/net/URL;

    invoke-direct {v1, v0}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "http://"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v1}, Ljava/net/URL;->getHost()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v0

    :goto_0
    return-object v0

    :catch_0
    move-exception v0

    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    const-string v0, ""

    goto :goto_0
.end method

.method public static c(Ljava/lang/String;)Ljava/lang/String;
    .locals 2

    if-eqz p0, :cond_0

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    if-lez v0, :cond_0

    const/4 v0, 0x0

    const-string v1, "."

    invoke-virtual {p0, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v1

    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcn/uc/a/a/a/a/k;->b(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :goto_0
    return-object v0

    :cond_0
    const/4 v0, 0x0

    goto :goto_0
.end method

.method public static d()Ljava/lang/String;
    .locals 1

    sget-object v0, Lcn/uc/a/a/a/a/k;->n:Ljava/lang/String;

    return-object v0
.end method

.method public static d(Ljava/lang/String;)V
    .locals 0

    sput-object p0, Lcn/uc/a/a/a/a/k;->n:Ljava/lang/String;

    return-void
.end method

.method public static e()V
    .locals 1

    sget-object v0, Lcn/uc/a/a/a/a;->a:Ljava/util/concurrent/ConcurrentHashMap;

    invoke-virtual {v0}, Ljava/util/concurrent/ConcurrentHashMap;->clear()V

    return-void
.end method
