.class public Lcom/dataeye/c/w;
.super Ljava/lang/Object;


# static fields
.field public static a:Z

.field public static b:Ljava/lang/String;

.field public static c:Ljava/lang/String;

.field public static d:Ljava/lang/String;

.field public static e:Lcom/dataeye/a/f;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    const/4 v0, 0x0

    sput-boolean v0, Lcom/dataeye/c/w;->a:Z

    const-string v0, ""

    sput-object v0, Lcom/dataeye/c/w;->b:Ljava/lang/String;

    const-string v0, ""

    sput-object v0, Lcom/dataeye/c/w;->c:Ljava/lang/String;

    const-string v0, ""

    sput-object v0, Lcom/dataeye/c/w;->d:Ljava/lang/String;

    const/4 v0, 0x0

    sput-object v0, Lcom/dataeye/c/w;->e:Lcom/dataeye/a/f;

    return-void
.end method

.method private static a(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    .locals 4

    const/4 v0, 0x0

    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v1

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v2

    const/16 v3, 0x80

    invoke-virtual {v1, v2, v3}, Landroid/content/pm/PackageManager;->getApplicationInfo(Ljava/lang/String;I)Landroid/content/pm/ApplicationInfo;

    move-result-object v1

    iget-object v1, v1, Landroid/content/pm/ApplicationInfo;->metaData:Landroid/os/Bundle;

    invoke-virtual {v1, p1}, Landroid/os/Bundle;->get(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    if-nez v1, :cond_0

    :goto_0
    return-object v0

    :cond_0
    invoke-virtual {v1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/String;->trim()Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v0

    goto :goto_0

    :catch_0
    move-exception v1

    goto :goto_0
.end method

.method public static a(Landroid/content/Context;)V
    .locals 2

    new-instance v0, Lcom/dataeye/a/f;

    invoke-direct {v0}, Lcom/dataeye/a/f;-><init>()V

    sput-object v0, Lcom/dataeye/c/w;->e:Lcom/dataeye/a/f;

    sget-object v0, Lcom/dataeye/c/w;->e:Lcom/dataeye/a/f;

    invoke-static {p0}, Lcom/dataeye/c/ab;->g(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Lcom/dataeye/a/f;->a:Ljava/lang/String;

    sget-object v0, Lcom/dataeye/c/w;->e:Lcom/dataeye/a/f;

    invoke-static {p0}, Lcom/dataeye/c/ab;->j(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Lcom/dataeye/a/f;->b:Ljava/lang/String;

    sget-object v0, Lcom/dataeye/c/w;->e:Lcom/dataeye/a/f;

    invoke-static {}, Lcom/dataeye/c/a;->j()Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Lcom/dataeye/a/f;->c:Ljava/lang/String;

    sget-object v0, Lcom/dataeye/c/w;->e:Lcom/dataeye/a/f;

    invoke-static {}, Lcom/dataeye/c/ab;->e()Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Lcom/dataeye/a/f;->d:Ljava/lang/String;

    sget-object v0, Lcom/dataeye/c/w;->e:Lcom/dataeye/a/f;

    invoke-static {}, Lcom/dataeye/c/ab;->f()Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Lcom/dataeye/a/f;->e:Ljava/lang/String;

    sget-object v0, Lcom/dataeye/c/w;->e:Lcom/dataeye/a/f;

    invoke-static {}, Lcom/dataeye/c/ab;->d()Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Lcom/dataeye/a/f;->f:Ljava/lang/String;

    sget-object v0, Lcom/dataeye/c/w;->e:Lcom/dataeye/a/f;

    invoke-static {}, Lcom/dataeye/c/ab;->g()Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Lcom/dataeye/a/f;->g:Ljava/lang/String;

    sget-object v0, Lcom/dataeye/c/w;->e:Lcom/dataeye/a/f;

    invoke-static {}, Lcom/dataeye/c/ab;->c()Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Lcom/dataeye/a/f;->h:Ljava/lang/String;

    sget-object v0, Lcom/dataeye/c/w;->e:Lcom/dataeye/a/f;

    invoke-static {p0}, Lcom/dataeye/c/ab;->i(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Lcom/dataeye/a/f;->i:Ljava/lang/String;

    sget-object v0, Lcom/dataeye/c/w;->e:Lcom/dataeye/a/f;

    invoke-static {p0}, Lcom/dataeye/c/ab;->l(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Lcom/dataeye/a/f;->j:Ljava/lang/String;

    sget-object v0, Lcom/dataeye/c/w;->e:Lcom/dataeye/a/f;

    invoke-static {}, Lcom/dataeye/c/ab;->h()Z

    move-result v1

    iput-boolean v1, v0, Lcom/dataeye/a/f;->k:Z

    return-void
.end method

.method public static a(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 2

    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_0

    invoke-static {p2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_0

    sput-object p1, Lcom/dataeye/c/w;->c:Ljava/lang/String;

    sput-object p2, Lcom/dataeye/c/w;->d:Ljava/lang/String;

    :cond_0
    invoke-static {p3}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_1

    const-string v0, "DC_APPVERSION"

    sget-object v1, Lcom/dataeye/c/w;->b:Ljava/lang/String;

    invoke-static {v0, v1}, Lcom/dataeye/c/y;->e(Ljava/lang/String;Ljava/lang/String;)V

    :cond_1
    sget-object v0, Lcom/dataeye/c/w;->c:Ljava/lang/String;

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_3

    invoke-static {p0}, Lcom/dataeye/c/w;->c(Landroid/content/Context;)V

    invoke-static {p0}, Lcom/dataeye/c/w;->b(Landroid/content/Context;)V

    sget-object v0, Lcom/dataeye/c/w;->c:Ljava/lang/String;

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_2

    const/4 v0, 0x0

    sput-boolean v0, Lcom/dataeye/c/w;->a:Z

    const-string v0, "DataEye SDK init fail , Please check APPID and CHANNELID in AndroidManifest.xml. "

    invoke-static {v0}, Lcom/dataeye/c/t;->c(Ljava/lang/String;)V

    :goto_0
    return-void

    :cond_2
    sget-object v0, Lcom/dataeye/c/w;->c:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v0

    const/16 v1, 0x20

    if-eq v0, v1, :cond_3

    const-string v0, "Warning: maybe APPID configuration error , please check it!"

    invoke-static {v0}, Lcom/dataeye/c/t;->c(Ljava/lang/String;)V

    :cond_3
    invoke-static {}, Lcom/dataeye/c/h;->b()Landroid/os/Handler;

    move-result-object v0

    new-instance v1, Lcom/dataeye/c/x;

    invoke-direct {v1, p0}, Lcom/dataeye/c/x;-><init>(Landroid/content/Context;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    invoke-static {p0}, Lcom/dataeye/c/ab;->f(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/dataeye/c/w;->b:Ljava/lang/String;

    const/4 v0, 0x1

    sput-boolean v0, Lcom/dataeye/c/w;->a:Z

    goto :goto_0
.end method

.method public static b(Landroid/content/Context;)V
    .locals 2

    const-string v0, "DC_CHANNEL"

    invoke-static {p0, v0}, Lcom/dataeye/c/w;->a(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_0

    const-string v0, ""

    sput-object v0, Lcom/dataeye/c/w;->d:Ljava/lang/String;

    :goto_0
    return-void

    :cond_0
    sput-object v0, Lcom/dataeye/c/w;->d:Ljava/lang/String;

    goto :goto_0
.end method

.method public static c(Landroid/content/Context;)V
    .locals 1

    const-string v0, "DC_APPID"

    invoke-static {p0, v0}, Lcom/dataeye/c/w;->a(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/dataeye/c/w;->c:Ljava/lang/String;

    return-void
.end method
