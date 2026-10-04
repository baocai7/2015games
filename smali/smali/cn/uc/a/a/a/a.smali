.class public Lcn/uc/a/a/a/a;
.super Ljava/lang/Object;


# static fields
.field public static a:Ljava/util/concurrent/ConcurrentHashMap; = null
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/concurrent/ConcurrentHashMap",
            "<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field public static final b:Ljava/lang/String; = "key_rootDir"

.field public static final c:Ljava/lang/String; = "key_gameId"

.field public static final d:Ljava/lang/String; = "key_ucid"

.field public static final e:Ljava/lang/String; = "key_mve"

.field public static final f:Ljava/lang/String; = "key_ve"

.field public static final g:Ljava/lang/String; = "key_using_widget"

.field public static final h:Ljava/lang/String; = "key_open_behaviors_logs"

.field public static final i:Ljava/lang/String; = "key_server_id"

.field public static final j:Ljava/lang/String; = "key_server_name"

.field public static final k:Ljava/lang/String; = "key_cp_id"

.field public static final l:Ljava/lang/String; = "key_channel_id"

.field public static m:Z = false

.field public static n:Ljava/util/HashMap; = null
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap",
            "<",
            "Ljava/lang/String;",
            "Ljava/lang/Long;",
            ">;"
        }
    .end annotation
.end field

.field public static o:Ljava/util/ArrayList; = null
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList",
            "<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field public static p:Z = false

.field public static final q:Ljava/lang/String; = "android"

.field public static final r:Ljava/lang/String;

.field public static final s:Ljava/lang/String;

.field private static final t:Ljava/lang/String; = "AppContext"

.field private static u:Landroid/content/Context;

.field private static v:Ljava/util/concurrent/ConcurrentHashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/concurrent/ConcurrentHashMap",
            "<",
            "Ljava/lang/String;",
            "Ljava/lang/Object;",
            ">;"
        }
    .end annotation
.end field

.field private static w:Ljava/lang/Object;


# direct methods
.method static constructor <clinit>()V
    .locals 2

    const/4 v1, 0x1

    new-instance v0, Ljava/util/concurrent/ConcurrentHashMap;

    invoke-direct {v0}, Ljava/util/concurrent/ConcurrentHashMap;-><init>()V

    sput-object v0, Lcn/uc/a/a/a/a;->a:Ljava/util/concurrent/ConcurrentHashMap;

    sput-boolean v1, Lcn/uc/a/a/a/a;->m:Z

    new-instance v0, Ljava/util/concurrent/ConcurrentHashMap;

    invoke-direct {v0}, Ljava/util/concurrent/ConcurrentHashMap;-><init>()V

    sput-object v0, Lcn/uc/a/a/a/a;->v:Ljava/util/concurrent/ConcurrentHashMap;

    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcn/uc/a/a/a/a;->w:Ljava/lang/Object;

    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    sput-object v0, Lcn/uc/a/a/a/a;->n:Ljava/util/HashMap;

    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    sput-object v0, Lcn/uc/a/a/a/a;->o:Ljava/util/ArrayList;

    sput-boolean v1, Lcn/uc/a/a/a/a;->p:Z

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "API Level-"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    sget-object v1, Landroid/os/Build$VERSION;->SDK:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, " - "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    sget-object v1, Landroid/os/Build;->MANUFACTURER:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "-"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    sget-object v1, Landroid/os/Build$VERSION;->RELEASE:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcn/uc/a/a/a/a;->r:Ljava/lang/String;

    sget-object v0, Landroid/os/Build;->MODEL:Ljava/lang/String;

    sput-object v0, Lcn/uc/a/a/a/a;->s:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static a()Landroid/content/Context;
    .locals 1

    sget-object v0, Lcn/uc/a/a/a/a;->u:Landroid/content/Context;

    return-object v0
.end method

.method public static a(Ljava/lang/String;)Ljava/lang/Object;
    .locals 4

    sget-boolean v0, Lcn/uc/a/a/a/a;->m:Z

    if-nez v0, :cond_0

    const-string v0, "Class AppContext not call initConfig()"

    invoke-static {v0}, Lcn/uc/a/a/a/b/c;->a(Ljava/lang/String;)V

    :cond_0
    sget-object v0, Lcn/uc/a/a/a/a;->v:Ljava/util/concurrent/ConcurrentHashMap;

    invoke-virtual {v0, p0}, Ljava/util/concurrent/ConcurrentHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    if-nez v0, :cond_1

    const-string v1, "AppContext"

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "This map contains no mapping for the key "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    :cond_1
    return-object v0
.end method

.method public static a(Landroid/content/Context;)V
    .locals 1

    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    sput-object v0, Lcn/uc/a/a/a/a;->u:Landroid/content/Context;

    return-void
.end method

.method public static a(Ljava/lang/String;Ljava/lang/Boolean;)V
    .locals 0

    invoke-static {p0, p1}, Lcn/uc/a/a/a/a;->a(Ljava/lang/String;Ljava/lang/Object;)V

    return-void
.end method

.method public static a(Ljava/lang/String;Ljava/lang/Integer;)V
    .locals 0

    invoke-static {p0, p1}, Lcn/uc/a/a/a/a;->a(Ljava/lang/String;Ljava/lang/Object;)V

    return-void
.end method

.method public static a(Ljava/lang/String;Ljava/lang/Object;)V
    .locals 1

    sget-object v0, Lcn/uc/a/a/a/a;->v:Ljava/util/concurrent/ConcurrentHashMap;

    invoke-virtual {v0, p0, p1}, Ljava/util/concurrent/ConcurrentHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    return-void
.end method

.method public static a(Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    invoke-static {p0, p1}, Lcn/uc/a/a/a/a;->a(Ljava/lang/String;Ljava/lang/Object;)V

    return-void
.end method

.method public static b(Ljava/lang/String;)I
    .locals 2

    const/4 v1, 0x0

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    sget-boolean v0, Lcn/uc/a/a/a/a;->m:Z

    if-nez v0, :cond_0

    const-string v0, "Class LogInfoConfig not call initConfig()"

    invoke-static {v0}, Lcn/uc/a/a/a/b/c;->a(Ljava/lang/String;)V

    :cond_0
    invoke-static {p0}, Lcn/uc/a/a/a/a;->a(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Integer;

    if-nez v0, :cond_1

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    :cond_1
    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    return v0
.end method

.method public static b(Landroid/content/Context;)Z
    .locals 4

    const/4 v3, 0x1

    sget-object v1, Lcn/uc/a/a/a/a;->w:Ljava/lang/Object;

    monitor-enter v1

    const/4 v0, 0x0

    :try_start_0
    invoke-static {p0, v0}, Lcn/uc/a/a/a/b/h;->a(Landroid/content/Context;Lcn/uc/a/a/a/h;)Ljava/lang/String;

    move-result-object v0

    const-string v2, "key_rootDir"

    invoke-static {v2, v0}, Lcn/uc/a/a/a/a;->a(Ljava/lang/String;Ljava/lang/Object;)V

    const/4 v0, 0x1

    sput-boolean v0, Lcn/uc/a/a/a/a;->m:Z

    monitor-exit v1

    return v3

    :catchall_0
    move-exception v0

    monitor-exit v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v0
.end method

.method public static c(Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    const-string v0, ""

    sget-boolean v0, Lcn/uc/a/a/a/a;->m:Z

    if-nez v0, :cond_0

    const-string v0, "Class LogInfoConfig not call initConfig()"

    invoke-static {v0}, Lcn/uc/a/a/a/b/c;->a(Ljava/lang/String;)V

    :cond_0
    invoke-static {p0}, Lcn/uc/a/a/a/a;->a(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    if-nez v0, :cond_1

    const-string v0, ""

    :cond_1
    return-object v0
.end method

.method public static d(Ljava/lang/String;)Ljava/lang/Boolean;
    .locals 2

    const/4 v1, 0x0

    invoke-static {v1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    sget-boolean v0, Lcn/uc/a/a/a/a;->m:Z

    if-nez v0, :cond_0

    const-string v0, "Class LogInfoConfig not call initConfig()"

    invoke-static {v0}, Lcn/uc/a/a/a/b/c;->a(Ljava/lang/String;)V

    :cond_0
    invoke-static {p0}, Lcn/uc/a/a/a/a;->a(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Boolean;

    if-nez v0, :cond_1

    invoke-static {v1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v0

    :cond_1
    return-object v0
.end method
