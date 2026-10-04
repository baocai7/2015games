.class public Lcn/uc/a/a/a/d;
.super Ljava/lang/Object;


# static fields
.field private static final a:Ljava/lang/String; = "http://sdk.g.uc.cn/cs/data/host"

.field private static final b:Ljava/lang/String; = "http://"

.field private static final c:Ljava/lang/String; = "/cs/data/host/"

.field private static final d:Ljava/lang/String; = "sdk.test4.g.uc.cn"

.field private static final e:Ljava/lang/String; = "http://sdk.test4.g.uc.cn/cs/data/host/"

.field private static f:Ljava/lang/String;

.field private static g:Z


# direct methods
.method static constructor <clinit>()V
    .locals 1

    const/4 v0, 0x0

    sput-object v0, Lcn/uc/a/a/a/d;->f:Ljava/lang/String;

    const/4 v0, 0x0

    sput-boolean v0, Lcn/uc/a/a/a/d;->g:Z

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static a()Ljava/lang/String;
    .locals 1

    sget-boolean v0, Lcn/uc/a/a/a/d;->g:Z

    if-eqz v0, :cond_1

    sget-object v0, Lcn/uc/a/a/a/d;->f:Ljava/lang/String;

    invoke-static {v0}, Lcn/uc/a/a/a/b/j;->k(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v0, "http://sdk.test4.g.uc.cn/cs/data/host/"

    :goto_0
    return-object v0

    :cond_0
    sget-object v0, Lcn/uc/a/a/a/d;->f:Ljava/lang/String;

    goto :goto_0

    :cond_1
    const-string v0, "http://sdk.g.uc.cn/cs/data/host"

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

    const-string v1, "/cs/data/host/"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcn/uc/a/a/a/d;->f:Ljava/lang/String;

    :cond_0
    return-void
.end method
