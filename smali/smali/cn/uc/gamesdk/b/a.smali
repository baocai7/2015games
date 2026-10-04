.class public Lcn/uc/gamesdk/b/a;
.super Ljava/lang/Object;


# static fields
.field private static final a:Ljava/lang/String; = "DexLoader"

.field private static final b:Ljava/lang/String; = "entry.xml"

.field private static final c:I = 0x1

.field private static final d:Ljava/lang/String; = "3.4.1"

.field private static e:Lcn/uc/gamesdk/b/a; = null

.field private static final k:Ljava/lang/String; = "odex"

.field private static final l:Ljava/lang/String; = "jars"

.field private static final u:Ljava/lang/String; = "ucgamesdk"

.field private static final v:Ljava/lang/String; = "ui"


# instance fields
.field private f:Landroid/content/Context;

.field private g:Ljava/lang/String;

.field private h:Ljava/lang/String;

.field private i:Ljava/lang/String;

.field private j:Ljava/lang/String;

.field private m:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap",
            "<",
            "Lcn/uc/gamesdk/iface/Commands;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private n:Ljava/util/LinkedHashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/LinkedHashMap",
            "<",
            "Ljava/lang/String;",
            "Lcn/uc/gamesdk/b/b$a;",
            ">;"
        }
    .end annotation
.end field

.field private o:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap",
            "<",
            "Ljava/lang/String;",
            "Lcn/uc/gamesdk/iface/IDispatcher;",
            ">;"
        }
    .end annotation
.end field

.field private p:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap",
            "<",
            "Lcn/uc/gamesdk/iface/Commands;",
            "Lcn/uc/gamesdk/iface/IDispatcher;",
            ">;"
        }
    .end annotation
.end field

.field private q:I

.field private r:I

.field private s:Z

.field private t:Landroid/content/res/AssetManager;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    const/4 v0, 0x0

    sput-object v0, Lcn/uc/gamesdk/b/a;->e:Lcn/uc/gamesdk/b/a;

    return-void
.end method

.method private constructor <init>()V
    .locals 2

    const/4 v1, 0x0

    const/4 v0, 0x0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object v0, p0, Lcn/uc/gamesdk/b/a;->f:Landroid/content/Context;

    iput-object v0, p0, Lcn/uc/gamesdk/b/a;->m:Ljava/util/HashMap;

    iput-object v0, p0, Lcn/uc/gamesdk/b/a;->n:Ljava/util/LinkedHashMap;

    iput-object v0, p0, Lcn/uc/gamesdk/b/a;->o:Ljava/util/HashMap;

    iput-object v0, p0, Lcn/uc/gamesdk/b/a;->p:Ljava/util/HashMap;

    iput v1, p0, Lcn/uc/gamesdk/b/a;->q:I

    const/4 v0, 0x2

    iput v0, p0, Lcn/uc/gamesdk/b/a;->r:I

    iput-boolean v1, p0, Lcn/uc/gamesdk/b/a;->s:Z

    invoke-virtual {p0}, Lcn/uc/gamesdk/b/a;->b()Z

    return-void
.end method

.method public static declared-synchronized a()Lcn/uc/gamesdk/b/a;
    .locals 2

    const-class v1, Lcn/uc/gamesdk/b/a;

    monitor-enter v1

    :try_start_0
    sget-object v0, Lcn/uc/gamesdk/b/a;->e:Lcn/uc/gamesdk/b/a;

    if-nez v0, :cond_0

    new-instance v0, Lcn/uc/gamesdk/b/a;

    invoke-direct {v0}, Lcn/uc/gamesdk/b/a;-><init>()V

    sput-object v0, Lcn/uc/gamesdk/b/a;->e:Lcn/uc/gamesdk/b/a;

    :cond_0
    sget-object v0, Lcn/uc/gamesdk/b/a;->e:Lcn/uc/gamesdk/b/a;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v1

    return-object v0

    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0
.end method

.method private a(Z)V
    .locals 6

    const/4 v0, 0x0

    const-string v1, "DexLoader"

    const-string v2, "clearRexData"

    const-string v3, "\u8d44\u6e90\u9700\u8981\u91cd\u7f6e"

    invoke-static {v1, v2, v3}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const/4 v1, 0x1

    invoke-static {v1}, Lcn/uc/gamesdk/c/a;->c(I)V

    const-string v1, ""

    invoke-static {v1}, Lcn/uc/gamesdk/c/a;->l(Ljava/lang/String;)V

    invoke-direct {p0}, Lcn/uc/gamesdk/b/a;->d()V

    invoke-direct {p0}, Lcn/uc/gamesdk/b/a;->i()V

    new-instance v1, Ljava/io/File;

    iget-object v2, p0, Lcn/uc/gamesdk/b/a;->g:Ljava/lang/String;

    invoke-direct {v1, v2}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/io/File;->exists()Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-virtual {v1}, Ljava/io/File;->listFiles()[Ljava/io/File;

    move-result-object v2

    array-length v3, v2

    move v1, v0

    :goto_0
    if-ge v1, v3, :cond_2

    aget-object v4, v2, v1

    invoke-virtual {v4}, Ljava/io/File;->isFile()Z

    move-result v5

    if-eqz v5, :cond_0

    invoke-virtual {v4}, Ljava/io/File;->delete()Z

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    invoke-virtual {v1}, Ljava/io/File;->mkdirs()Z

    :cond_2
    new-instance v1, Ljava/io/File;

    iget-object v2, p0, Lcn/uc/gamesdk/b/a;->j:Ljava/lang/String;

    invoke-direct {v1, v2}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/io/File;->exists()Z

    move-result v2

    if-eqz v2, :cond_4

    invoke-virtual {v1}, Ljava/io/File;->listFiles()[Ljava/io/File;

    move-result-object v1

    array-length v2, v1

    :goto_1
    if-ge v0, v2, :cond_5

    aget-object v3, v1, v0

    invoke-virtual {v3}, Ljava/io/File;->isFile()Z

    move-result v4

    if-eqz v4, :cond_3

    invoke-virtual {v3}, Ljava/io/File;->delete()Z

    :cond_3
    add-int/lit8 v0, v0, 0x1

    goto :goto_1

    :cond_4
    invoke-virtual {v1}, Ljava/io/File;->mkdirs()Z

    :cond_5
    return-void
.end method

.method private a(I)Z
    .locals 5

    const/4 v0, 0x0

    invoke-direct {p0}, Lcn/uc/gamesdk/b/a;->f()D

    move-result-wide v1

    int-to-double v3, p1

    cmpl-double v1, v1, v3

    if-lez v1, :cond_0

    const/4 v0, 0x1

    :cond_0
    return v0
.end method

.method private d()V
    .locals 4

    invoke-static {}, Lcn/uc/gamesdk/c/a;->x()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcn/uc/gamesdk/d/f;->c(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_0

    const-string v0, "DexLoader"

    const-string v1, "setJarPath"

    const-string v2, "\u4f7f\u7528cache\u76ee\u5f55jar"

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v1, p0, Lcn/uc/gamesdk/b/a;->f:Landroid/content/Context;

    invoke-virtual {v1}, Landroid/content/Context;->getCacheDir()Ljava/io/File;

    move-result-object v1

    invoke-virtual {v1}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    sget-object v1, Ljava/io/File;->separator:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "jars"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcn/uc/gamesdk/b/a;->g:Ljava/lang/String;

    :goto_0
    return-void

    :cond_0
    const-string v1, "DexLoader"

    const-string v2, "setJarPath"

    const-string v3, "\u4f7f\u7528\u8d44\u6e90\u76ee\u5f55jar"

    invoke-static {v1, v2, v3}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v2, p0, Lcn/uc/gamesdk/b/a;->f:Landroid/content/Context;

    invoke-virtual {v2}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v2

    invoke-virtual {v2}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

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

    const-string v2, "ui"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    sget-object v2, Ljava/io/File;->separator:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    sget-object v1, Ljava/io/File;->separator:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "jars"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcn/uc/gamesdk/b/a;->g:Ljava/lang/String;

    goto :goto_0
.end method

.method private e()Z
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;,
            Lorg/xmlpull/v1/XmlPullParserException;
        }
    .end annotation

    new-instance v0, Lcn/uc/gamesdk/b/b;

    invoke-direct {v0}, Lcn/uc/gamesdk/b/b;-><init>()V

    iget-object v1, p0, Lcn/uc/gamesdk/b/a;->h:Ljava/lang/String;

    invoke-virtual {v0, v1}, Lcn/uc/gamesdk/b/b;->a(Ljava/lang/String;)V

    invoke-virtual {v0}, Lcn/uc/gamesdk/b/b;->b()Ljava/util/HashMap;

    move-result-object v1

    iput-object v1, p0, Lcn/uc/gamesdk/b/a;->m:Ljava/util/HashMap;

    invoke-virtual {v0}, Lcn/uc/gamesdk/b/b;->c()Ljava/util/LinkedHashMap;

    move-result-object v1

    iput-object v1, p0, Lcn/uc/gamesdk/b/a;->n:Ljava/util/LinkedHashMap;

    invoke-virtual {v0}, Lcn/uc/gamesdk/b/b;->a()I

    move-result v0

    iput v0, p0, Lcn/uc/gamesdk/b/a;->r:I

    const/4 v0, 0x1

    return v0
.end method

.method private f()D
    .locals 4

    sget-object v0, Lcn/uc/gamesdk/a/d;->b:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v0

    invoke-virtual {v0}, Ljava/io/File;->getPath()Ljava/lang/String;

    move-result-object v0

    new-instance v1, Landroid/os/StatFs;

    invoke-direct {v1, v0}, Landroid/os/StatFs;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1}, Landroid/os/StatFs;->getBlockSize()I

    move-result v0

    int-to-long v2, v0

    invoke-virtual {v1}, Landroid/os/StatFs;->getAvailableBlocks()I

    move-result v0

    int-to-long v0, v0

    mul-long/2addr v0, v2

    long-to-double v0, v0

    const-wide/high16 v2, 0x4130000000000000L    # 1048576.0

    div-double/2addr v0, v2

    return-wide v0
.end method

.method private g()Z
    .locals 8

    const/4 v0, 0x1

    new-instance v1, Ljava/io/File;

    iget-object v2, p0, Lcn/uc/gamesdk/b/a;->h:Ljava/lang/String;

    invoke-direct {v1, v2}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/io/File;->exists()Z

    move-result v1

    if-nez v1, :cond_0

    move v7, v0

    :goto_0
    if-eqz v7, :cond_2

    invoke-static {}, Lcn/uc/gamesdk/c/a;->x()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcn/uc/gamesdk/d/f;->c(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_1

    const-string v0, "DexLoader"

    const-string v1, "needResetUI"

    const-string v2, "\u6ca1\u6709\u8fdb\u884c\u8fc7\u8d44\u6e90\u91ca\u653e"

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :goto_1
    return v7

    :cond_0
    const/4 v7, 0x0

    goto :goto_0

    :cond_1
    const-string v0, "DexLoader"

    const-string v1, "needResetUI"

    const-string v2, "resource"

    const-string v3, "\u5df2\u91ca\u653e\u7684H5\u8d44\u6e90\u6587\u4ef6\u4e2d\u7f3a\u5c11entry.xml\u6587\u4ef6"

    const/4 v4, 0x0

    const/4 v5, 0x3

    sget-object v6, Lcn/uc/gamesdk/a/a;->a:Ljava/lang/String;

    invoke-static/range {v0 .. v6}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;ILjava/lang/String;)V

    goto :goto_1

    :cond_2
    invoke-static {}, Lcn/uc/gamesdk/c/a;->w()I

    move-result v1

    if-ne v0, v1, :cond_3

    const-string v1, "DexLoader"

    const-string v2, "needResetUI"

    const-string v3, "\u8d44\u6e90\u5f02\u5e38\uff0c\u5f3a\u5236\u8d44\u6e90\u91cd\u7f6e"

    invoke-static {v1, v2, v3}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    move v7, v0

    goto :goto_1

    :cond_3
    :try_start_0
    new-instance v1, Lcn/uc/gamesdk/b/b;

    invoke-direct {v1}, Lcn/uc/gamesdk/b/b;-><init>()V

    iget-object v2, p0, Lcn/uc/gamesdk/b/a;->h:Ljava/lang/String;

    invoke-virtual {v1, v2}, Lcn/uc/gamesdk/b/b;->a(Ljava/lang/String;)V

    invoke-virtual {v1}, Lcn/uc/gamesdk/b/b;->d()Ljava/lang/String;

    move-result-object v1

    const-string v2, "3.4.1"

    invoke-static {v1, v2}, Lcn/uc/gamesdk/d/a;->a(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catch Lorg/xmlpull/v1/XmlPullParserException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_1

    move-result v1

    if-gez v1, :cond_4

    :goto_2
    move v7, v0

    goto :goto_1

    :catch_0
    move-exception v0

    const-string v0, "DexLoader"

    const-string v1, "needResetUI"

    const-string v2, "XML\u89e3\u6790\u9519\u8bef"

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->c(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_1

    :catch_1
    move-exception v0

    const-string v0, "DexLoader"

    const-string v1, "needResetUI"

    const-string v2, "XML\u8bfb\u53d6\u9519\u8bef"

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->c(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_1

    :cond_4
    move v0, v7

    goto :goto_2
.end method

.method private h()Z
    .locals 8

    const/4 v0, 0x1

    const/4 v7, 0x0

    const-string v1, "DexLoader"

    const-string v2, "releaseXml"

    const-string v3, "==releaseXML=="

    invoke-static {v1, v2, v3}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    invoke-direct {p0, v0}, Lcn/uc/gamesdk/b/a;->a(I)Z

    move-result v1

    if-eqz v1, :cond_1

    const/16 v1, 0x400

    new-array v1, v1, [B

    :try_start_0
    iget-object v2, p0, Lcn/uc/gamesdk/b/a;->t:Landroid/content/res/AssetManager;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v4, p0, Lcn/uc/gamesdk/b/a;->i:Ljava/lang/String;

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, "entry.xml"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/content/res/AssetManager;->open(Ljava/lang/String;)Ljava/io/InputStream;

    move-result-object v2

    new-instance v3, Ljava/io/File;

    iget-object v4, p0, Lcn/uc/gamesdk/b/a;->h:Ljava/lang/String;

    invoke-direct {v3, v4}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3}, Ljava/io/File;->createNewFile()Z

    new-instance v4, Ljava/io/FileOutputStream;

    invoke-direct {v4, v3}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    :goto_0
    invoke-virtual {v2, v1}, Ljava/io/InputStream;->read([B)I

    move-result v3

    if-lez v3, :cond_0

    const/4 v5, 0x0

    invoke-virtual {v4, v1, v5, v3}, Ljava/io/FileOutputStream;->write([BII)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_1

    goto :goto_0

    :catch_0
    move-exception v4

    const-string v0, "DexLoader"

    const-string v1, "releaseXml"

    const-string v2, "resource"

    const-string v3, "\u8bfb\u53d6entry.xml\u914d\u7f6e\u6587\u4ef6\u5931\u8d25"

    const/4 v5, 0x2

    sget-object v6, Lcn/uc/gamesdk/a/a;->a:Ljava/lang/String;

    invoke-static/range {v0 .. v6}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;ILjava/lang/String;)V

    :goto_1
    move v0, v7

    :goto_2
    return v0

    :cond_0
    :try_start_1
    invoke-virtual {v2}, Ljava/io/InputStream;->close()V

    invoke-virtual {v4}, Ljava/io/FileOutputStream;->close()V
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0
    .catch Ljava/lang/RuntimeException; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_2

    :catch_1
    move-exception v0

    invoke-virtual {v0}, Ljava/lang/RuntimeException;->printStackTrace()V

    goto :goto_1

    :cond_1
    const-string v0, "DexLoader"

    const-string v1, "releaseXml"

    const-string v2, "\u5185\u5b58\u4e0d\u8db3\uff0c\u91ca\u653exml\u914d\u7f6e\u6587\u4ef6\u5931\u8d25"

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->c(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_1
.end method

.method private i()V
    .locals 2

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v1, p0, Lcn/uc/gamesdk/b/a;->g:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    sget-object v1, Ljava/io/File;->separator:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "entry.xml"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcn/uc/gamesdk/b/a;->h:Ljava/lang/String;

    return-void
.end method

.method private j()Z
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;,
            Lorg/xmlpull/v1/XmlPullParserException;
        }
    .end annotation

    const/4 v0, 0x0

    invoke-direct {p0}, Lcn/uc/gamesdk/b/a;->i()V

    invoke-direct {p0}, Lcn/uc/gamesdk/b/a;->g()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-direct {p0, v0}, Lcn/uc/gamesdk/b/a;->a(Z)V

    invoke-direct {p0}, Lcn/uc/gamesdk/b/a;->h()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-direct {p0}, Lcn/uc/gamesdk/b/a;->e()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-direct {p0}, Lcn/uc/gamesdk/b/a;->k()Z

    move-result v0

    :cond_0
    :goto_0
    return v0

    :cond_1
    invoke-direct {p0}, Lcn/uc/gamesdk/b/a;->e()Z

    move-result v0

    goto :goto_0
.end method

.method private k()Z
    .locals 9

    const/4 v1, 0x1

    const/4 v7, 0x0

    const-string v0, "DexLoader"

    const-string v2, "releaseJar"

    const-string v3, "==releaseJar=="

    invoke-static {v0, v2, v3}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    iget v0, p0, Lcn/uc/gamesdk/b/a;->r:I

    invoke-direct {p0, v0}, Lcn/uc/gamesdk/b/a;->a(I)Z

    move-result v0

    if-eqz v0, :cond_2

    iget-object v0, p0, Lcn/uc/gamesdk/b/a;->n:Ljava/util/LinkedHashMap;

    invoke-virtual {v0}, Ljava/util/LinkedHashMap;->keySet()Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :goto_0
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    iget-object v3, p0, Lcn/uc/gamesdk/b/a;->n:Ljava/util/LinkedHashMap;

    invoke-virtual {v3, v0}, Ljava/util/LinkedHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcn/uc/gamesdk/b/b$a;

    iget-object v0, v0, Lcn/uc/gamesdk/b/b$a;->b:Ljava/lang/String;

    const/16 v3, 0x400

    new-array v3, v3, [B

    :try_start_0
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v5, p0, Lcn/uc/gamesdk/b/a;->i:Ljava/lang/String;

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    iget-object v5, p0, Lcn/uc/gamesdk/b/a;->t:Landroid/content/res/AssetManager;

    invoke-virtual {v5, v4}, Landroid/content/res/AssetManager;->open(Ljava/lang/String;)Ljava/io/InputStream;

    move-result-object v4

    new-instance v5, Ljava/io/File;

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v8, p0, Lcn/uc/gamesdk/b/a;->g:Ljava/lang/String;

    invoke-virtual {v6, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    sget-object v8, Ljava/io/File;->separator:Ljava/lang/String;

    invoke-virtual {v6, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {v5, v0}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {v5}, Ljava/io/File;->createNewFile()Z

    new-instance v0, Ljava/io/FileOutputStream;

    invoke-direct {v0, v5}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    :goto_1
    invoke-virtual {v4, v3}, Ljava/io/InputStream;->read([B)I

    move-result v5

    if-lez v5, :cond_0

    const/4 v6, 0x0

    invoke-virtual {v0, v3, v6, v5}, Ljava/io/FileOutputStream;->write([BII)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_1

    goto :goto_1

    :catch_0
    move-exception v4

    const-string v0, "dexLoading"

    const-string v2, "A"

    const-string v3, "\u627e\u4e0d\u5230\u5bf9\u5e94\u7684Jar\u5305,\u91ca\u653e\u5931\u8d25"

    invoke-static {v0, v2, v3, v1}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)V

    const-string v0, "DexLoader"

    const-string v1, "releaseJar"

    const-string v2, "resource"

    const-string v3, "\u627e\u4e0d\u5230\u5bf9\u5e94\u7684Jar\u5305,\u91ca\u653e\u5931\u8d25"

    const/4 v5, 0x2

    sget-object v6, Lcn/uc/gamesdk/a/a;->a:Ljava/lang/String;

    invoke-static/range {v0 .. v6}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;ILjava/lang/String;)V

    move v0, v7

    :goto_2
    return v0

    :cond_0
    :try_start_1
    invoke-virtual {v4}, Ljava/io/InputStream;->close()V

    invoke-virtual {v0}, Ljava/io/FileOutputStream;->close()V
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0
    .catch Ljava/lang/RuntimeException; {:try_start_1 .. :try_end_1} :catch_1

    goto/16 :goto_0

    :catch_1
    move-exception v0

    invoke-virtual {v0}, Ljava/lang/RuntimeException;->printStackTrace()V

    move v0, v7

    goto :goto_2

    :cond_1
    move v0, v1

    goto :goto_2

    :cond_2
    const-string v0, "dexLoading"

    const-string v2, "A"

    const-string v3, "\u5185\u5b58\u4e0d\u8db3%dm\uff0c\u91ca\u653ejar\u5931\u8d25"

    new-array v4, v1, [Ljava/lang/Object;

    iget v5, p0, Lcn/uc/gamesdk/b/a;->r:I

    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    aput-object v5, v4, v7

    invoke-static {v3, v4}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    invoke-static {v0, v2, v3, v1}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)V

    const-string v0, "DexLoader"

    const-string v2, "releaseJar"

    const-string v3, "\u5185\u5b58\u4e0d\u8db3%dm\uff0c\u91ca\u653ejar\u5931\u8d25"

    new-array v1, v1, [Ljava/lang/Object;

    iget v4, p0, Lcn/uc/gamesdk/b/a;->r:I

    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    aput-object v4, v1, v7

    invoke-static {v3, v1}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v2, v1}, Lcn/uc/a/a/a/i;->c(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    move v0, v7

    goto :goto_2
.end method

.method private l()Ljava/util/Map;
    .locals 9
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/Map",
            "<",
            "Lcn/uc/gamesdk/iface/Commands;",
            "Lcn/uc/gamesdk/iface/IDispatcher;",
            ">;"
        }
    .end annotation

    const/4 v8, 0x0

    const/4 v4, 0x0

    const/4 v5, 0x1

    iget-object v0, p0, Lcn/uc/gamesdk/b/a;->o:Ljava/util/HashMap;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcn/uc/gamesdk/b/a;->o:Ljava/util/HashMap;

    invoke-virtual {v0}, Ljava/util/HashMap;->clear()V

    iput-object v4, p0, Lcn/uc/gamesdk/b/a;->o:Ljava/util/HashMap;

    :cond_0
    iget-object v0, p0, Lcn/uc/gamesdk/b/a;->p:Ljava/util/HashMap;

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcn/uc/gamesdk/b/a;->p:Ljava/util/HashMap;

    invoke-virtual {v0}, Ljava/util/HashMap;->clear()V

    iput-object v4, p0, Lcn/uc/gamesdk/b/a;->p:Ljava/util/HashMap;

    :cond_1
    invoke-direct {p0, v8}, Lcn/uc/gamesdk/b/a;->a(Z)V

    iget v0, p0, Lcn/uc/gamesdk/b/a;->q:I

    if-ge v0, v5, :cond_2

    iget v0, p0, Lcn/uc/gamesdk/b/a;->q:I

    add-int/lit8 v0, v0, 0x1

    iput v0, p0, Lcn/uc/gamesdk/b/a;->q:I

    invoke-virtual {p0}, Lcn/uc/gamesdk/b/a;->c()Ljava/util/Map;

    move-result-object v4

    :goto_0
    return-object v4

    :cond_2
    const-string v0, "DexLoader"

    const-string v1, "reCreate"

    const-string v2, "resource"

    const-string v3, "\u8fbe\u5230\u6700\u5927\u52a8\u6001\u52a0\u8f7d\u91cd\u8bd5\u6b21\u6570\uff1a%s,\u5f02\u5e38\u505c\u6b62"

    new-array v6, v5, [Ljava/lang/Object;

    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v7

    aput-object v7, v6, v8

    invoke-static {v3, v6}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    sget-object v6, Lcn/uc/gamesdk/a/a;->a:Ljava/lang/String;

    invoke-static/range {v0 .. v6}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;ILjava/lang/String;)V

    goto :goto_0
.end method


# virtual methods
.method public a(Lcn/uc/gamesdk/iface/Commands;)Lcn/uc/gamesdk/iface/IDispatcher;
    .locals 1

    iget-boolean v0, p0, Lcn/uc/gamesdk/b/a;->s:Z

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcn/uc/gamesdk/b/a;->p:Ljava/util/HashMap;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcn/uc/gamesdk/b/a;->p:Ljava/util/HashMap;

    invoke-virtual {v0, p1}, Ljava/util/HashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcn/uc/gamesdk/b/a;->p:Ljava/util/HashMap;

    invoke-virtual {v0, p1}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcn/uc/gamesdk/iface/IDispatcher;

    :goto_0
    return-object v0

    :cond_0
    const/4 v0, 0x0

    goto :goto_0
.end method

.method public a(Ljava/lang/String;)Lcn/uc/gamesdk/iface/IDispatcher;
    .locals 1

    iget-boolean v0, p0, Lcn/uc/gamesdk/b/a;->s:Z

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcn/uc/gamesdk/b/a;->n:Ljava/util/LinkedHashMap;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcn/uc/gamesdk/b/a;->n:Ljava/util/LinkedHashMap;

    invoke-virtual {v0, p1}, Ljava/util/LinkedHashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcn/uc/gamesdk/b/a;->o:Ljava/util/HashMap;

    invoke-virtual {v0, p1}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcn/uc/gamesdk/iface/IDispatcher;

    :goto_0
    return-object v0

    :cond_0
    const/4 v0, 0x0

    goto :goto_0
.end method

.method public b()Z
    .locals 3

    const/4 v0, 0x0

    sget-object v1, Lcn/uc/gamesdk/a/d;->b:Landroid/content/Context;

    if-eqz v1, :cond_1

    sget-object v1, Lcn/uc/gamesdk/a/d;->b:Landroid/content/Context;

    invoke-virtual {v1}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object v1

    iput-object v1, p0, Lcn/uc/gamesdk/b/a;->f:Landroid/content/Context;

    iget-object v1, p0, Lcn/uc/gamesdk/b/a;->f:Landroid/content/Context;

    invoke-virtual {v1}, Landroid/content/Context;->getAssets()Landroid/content/res/AssetManager;

    move-result-object v1

    iput-object v1, p0, Lcn/uc/gamesdk/b/a;->t:Landroid/content/res/AssetManager;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v2, p0, Lcn/uc/gamesdk/b/a;->f:Landroid/content/Context;

    invoke-virtual {v2}, Landroid/content/Context;->getCacheDir()Ljava/io/File;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v1

    sget-object v2, Ljava/io/File;->separator:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "jars"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    sget-object v2, Ljava/io/File;->separator:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "odex"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    iput-object v1, p0, Lcn/uc/gamesdk/b/a;->j:Ljava/lang/String;

    new-instance v1, Ljava/io/File;

    iget-object v2, p0, Lcn/uc/gamesdk/b/a;->j:Ljava/lang/String;

    invoke-direct {v1, v2}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/io/File;->exists()Z

    move-result v2

    if-nez v2, :cond_0

    invoke-virtual {v1}, Ljava/io/File;->mkdirs()Z

    :cond_0
    invoke-static {}, Lcn/uc/gamesdk/a/f;->b()V

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "common"

    invoke-static {v2}, Lcn/uc/gamesdk/a/f;->a(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    sget-object v2, Ljava/io/File;->separator:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "jars"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    sget-object v2, Ljava/io/File;->separator:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    iput-object v1, p0, Lcn/uc/gamesdk/b/a;->i:Ljava/lang/String;

    iput v0, p0, Lcn/uc/gamesdk/b/a;->q:I

    const/4 v0, 0x1

    :cond_1
    return v0
.end method

.method public declared-synchronized c()Ljava/util/Map;
    .locals 9
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/Map",
            "<",
            "Lcn/uc/gamesdk/iface/Commands;",
            "Lcn/uc/gamesdk/iface/IDispatcher;",
            ">;"
        }
    .end annotation

    const/4 v0, 0x0

    monitor-enter p0

    :try_start_0
    const-string v1, "DexLoader"

    const-string v2, "creator"

    const-string v3, "==creator=="

    invoke-static {v1, v2, v3}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    iget-object v1, p0, Lcn/uc/gamesdk/b/a;->f:Landroid/content/Context;

    if-nez v1, :cond_1

    invoke-virtual {p0}, Lcn/uc/gamesdk/b/a;->b()Z

    move-result v1

    if-nez v1, :cond_1

    const-string v1, "DexLoader"

    const-string v2, "creator"

    const-string v3, "DexLoader\u521d\u59cb\u5316\u5931\u8d25"

    invoke-static {v1, v2, v3}, Lcn/uc/a/a/a/i;->c(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    :cond_0
    :goto_0
    monitor-exit p0

    return-object v0

    :cond_1
    :try_start_1
    iget-boolean v1, p0, Lcn/uc/gamesdk/b/a;->s:Z

    if-eqz v1, :cond_2

    iget-object v1, p0, Lcn/uc/gamesdk/b/a;->p:Ljava/util/HashMap;

    if-eqz v1, :cond_2

    const-string v0, "DexLoader"

    const-string v1, "creator"

    const-string v2, "jar\u5305\u5df2\u7ecf\u52a0\u8f7d\u6210\u529f"

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    iget-object v0, p0, Lcn/uc/gamesdk/b/a;->p:Ljava/util/HashMap;

    goto :goto_0

    :cond_2
    new-instance v1, Ljava/util/HashMap;

    invoke-direct {v1}, Ljava/util/HashMap;-><init>()V

    iput-object v1, p0, Lcn/uc/gamesdk/b/a;->p:Ljava/util/HashMap;

    invoke-direct {p0}, Lcn/uc/gamesdk/b/a;->d()V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    :try_start_2
    invoke-direct {p0}, Lcn/uc/gamesdk/b/a;->j()Z

    move-result v1

    if-eqz v1, :cond_0

    new-instance v1, Ljava/util/HashMap;

    invoke-direct {v1}, Ljava/util/HashMap;-><init>()V

    iput-object v1, p0, Lcn/uc/gamesdk/b/a;->o:Ljava/util/HashMap;

    iget-object v1, p0, Lcn/uc/gamesdk/b/a;->n:Ljava/util/LinkedHashMap;

    invoke-virtual {v1}, Ljava/util/LinkedHashMap;->keySet()Ljava/util/Set;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v4

    move-object v2, v0

    :goto_1
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_4

    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    iget-object v1, p0, Lcn/uc/gamesdk/b/a;->n:Ljava/util/LinkedHashMap;

    invoke-virtual {v1, v0}, Ljava/util/LinkedHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcn/uc/gamesdk/b/b$a;

    iget-object v5, v1, Lcn/uc/gamesdk/b/b$a;->a:Ljava/lang/String;

    iget-object v1, v1, Lcn/uc/gamesdk/b/b$a;->b:Ljava/lang/String;

    new-instance v3, Ldalvik/system/DexClassLoader;

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v7, p0, Lcn/uc/gamesdk/b/a;->g:Ljava/lang/String;

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    sget-object v7, Ljava/io/File;->separator:Ljava/lang/String;

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    iget-object v7, p0, Lcn/uc/gamesdk/b/a;->j:Ljava/lang/String;

    const/4 v8, 0x0

    if-nez v2, :cond_3

    iget-object v1, p0, Lcn/uc/gamesdk/b/a;->f:Landroid/content/Context;

    invoke-virtual {v1}, Landroid/content/Context;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v1

    :goto_2
    invoke-direct {v3, v6, v7, v8, v1}, Ldalvik/system/DexClassLoader;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/ClassLoader;)V

    invoke-virtual {v3, v5}, Ldalvik/system/DexClassLoader;->loadClass(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1

    const-string v2, "getInstance"

    const/4 v5, 0x0

    new-array v5, v5, [Ljava/lang/Class;

    invoke-virtual {v1, v2, v5}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v1

    const/4 v2, 0x0

    const/4 v5, 0x0

    new-array v5, v5, [Ljava/lang/Object;

    invoke-virtual {v1, v2, v5}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcn/uc/gamesdk/iface/IDispatcher;

    iget-object v2, p0, Lcn/uc/gamesdk/b/a;->o:Ljava/util/HashMap;

    invoke-virtual {v2, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-object v2, v3

    goto :goto_1

    :cond_3
    move-object v1, v2

    goto :goto_2

    :cond_4
    iget-object v0, p0, Lcn/uc/gamesdk/b/a;->m:Ljava/util/HashMap;

    invoke-virtual {v0}, Ljava/util/HashMap;->keySet()Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :cond_5
    :goto_3
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_7

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcn/uc/gamesdk/iface/Commands;

    iget-object v1, p0, Lcn/uc/gamesdk/b/a;->m:Ljava/util/HashMap;

    invoke-virtual {v1, v0}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    iget-object v3, p0, Lcn/uc/gamesdk/b/a;->o:Ljava/util/HashMap;

    invoke-virtual {v3, v1}, Ljava/util/HashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_6

    iget-object v3, p0, Lcn/uc/gamesdk/b/a;->o:Ljava/util/HashMap;

    invoke-virtual {v3, v1}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcn/uc/gamesdk/iface/IDispatcher;

    if-eqz v1, :cond_5

    iget-object v3, p0, Lcn/uc/gamesdk/b/a;->p:Ljava/util/HashMap;

    invoke-virtual {v3, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_2
    .catch Ljava/lang/ClassNotFoundException; {:try_start_2 .. :try_end_2} :catch_0
    .catch Ljava/lang/IllegalAccessException; {:try_start_2 .. :try_end_2} :catch_1
    .catch Ljava/io/IOException; {:try_start_2 .. :try_end_2} :catch_2
    .catch Lorg/xmlpull/v1/XmlPullParserException; {:try_start_2 .. :try_end_2} :catch_3
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_2 .. :try_end_2} :catch_4
    .catch Ljava/lang/NoSuchMethodException; {:try_start_2 .. :try_end_2} :catch_5
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_6
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    goto :goto_3

    :catch_0
    move-exception v4

    :try_start_3
    const-string v0, "dexLoading"

    const-string v1, "A"

    const-string v2, "\u627e\u4e0d\u5230\u5bf9\u5e94jar\u5305\u5165\u53e3\u7c7b"

    const/4 v3, 0x1

    invoke-static {v0, v1, v2, v3}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)V

    const-string v0, "DexLoader"

    const-string v1, "creator"

    const-string v2, "resource"

    const-string v3, "\u627e\u4e0d\u5230\u5bf9\u5e94jar\u5305\u5165\u53e3\u7c7b "

    const/4 v5, 0x2

    sget-object v6, Lcn/uc/gamesdk/a/a;->a:Ljava/lang/String;

    invoke-static/range {v0 .. v6}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;ILjava/lang/String;)V

    :goto_4
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcn/uc/gamesdk/b/a;->s:Z

    invoke-direct {p0}, Lcn/uc/gamesdk/b/a;->l()Ljava/util/Map;
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    move-result-object v0

    goto/16 :goto_0

    :cond_6
    :try_start_4
    new-instance v0, Ljava/lang/ClassNotFoundException;

    invoke-direct {v0}, Ljava/lang/ClassNotFoundException;-><init>()V

    throw v0
    :try_end_4
    .catch Ljava/lang/ClassNotFoundException; {:try_start_4 .. :try_end_4} :catch_0
    .catch Ljava/lang/IllegalAccessException; {:try_start_4 .. :try_end_4} :catch_1
    .catch Ljava/io/IOException; {:try_start_4 .. :try_end_4} :catch_2
    .catch Lorg/xmlpull/v1/XmlPullParserException; {:try_start_4 .. :try_end_4} :catch_3
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_4 .. :try_end_4} :catch_4
    .catch Ljava/lang/NoSuchMethodException; {:try_start_4 .. :try_end_4} :catch_5
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_6
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    :catch_1
    move-exception v4

    :try_start_5
    const-string v0, "dexLoading"

    const-string v1, "A"

    const-string v2, "\u521b\u5efajar\u5165\u53e3\u7c7b\u5b9e\u4f8b\u5931\u8d25"

    const/4 v3, 0x1

    invoke-static {v0, v1, v2, v3}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)V

    const-string v0, "DexLoader"

    const-string v1, "creator"

    const-string v2, "INNER"

    const-string v3, "\u521b\u5efajar\u5165\u53e3\u7c7b\u5b9e\u4f8b\u5931\u8d25"

    const/4 v5, 0x2

    sget-object v6, Lcn/uc/gamesdk/a/a;->a:Ljava/lang/String;

    invoke-static/range {v0 .. v6}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;ILjava/lang/String;)V
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_0

    goto :goto_4

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0

    :cond_7
    :try_start_6
    iget-object v0, p0, Lcn/uc/gamesdk/b/a;->o:Ljava/util/HashMap;

    invoke-virtual {v0}, Ljava/util/HashMap;->keySet()Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_5
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_8

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    iget-object v2, p0, Lcn/uc/gamesdk/b/a;->o:Ljava/util/HashMap;

    invoke-virtual {v2, v0}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcn/uc/gamesdk/iface/IDispatcher;

    iget-object v2, p0, Lcn/uc/gamesdk/b/a;->f:Landroid/content/Context;

    sget-object v3, Lcn/uc/gamesdk/a/a;->b:Ljava/lang/String;

    invoke-static {}, Lcn/uc/gamesdk/a;->a()Lcn/uc/gamesdk/a;

    move-result-object v4

    iget-object v5, p0, Lcn/uc/gamesdk/b/a;->p:Ljava/util/HashMap;

    invoke-interface {v0, v2, v3, v4, v5}, Lcn/uc/gamesdk/iface/IDispatcher;->register(Landroid/content/Context;Ljava/lang/String;Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;Ljava/util/HashMap;)V
    :try_end_6
    .catch Ljava/lang/ClassNotFoundException; {:try_start_6 .. :try_end_6} :catch_0
    .catch Ljava/lang/IllegalAccessException; {:try_start_6 .. :try_end_6} :catch_1
    .catch Ljava/io/IOException; {:try_start_6 .. :try_end_6} :catch_2
    .catch Lorg/xmlpull/v1/XmlPullParserException; {:try_start_6 .. :try_end_6} :catch_3
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_6 .. :try_end_6} :catch_4
    .catch Ljava/lang/NoSuchMethodException; {:try_start_6 .. :try_end_6} :catch_5
    .catch Ljava/lang/Exception; {:try_start_6 .. :try_end_6} :catch_6
    .catchall {:try_start_6 .. :try_end_6} :catchall_0

    goto :goto_5

    :catch_2
    move-exception v4

    :try_start_7
    const-string v0, "dexLoading"

    const-string v1, "A"

    const-string v2, "IOException"

    const/4 v3, 0x1

    invoke-static {v0, v1, v2, v3}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)V

    const-string v0, "DexLoader"

    const-string v1, "creator"

    const-string v2, "io"

    invoke-virtual {v4}, Ljava/io/IOException;->getMessage()Ljava/lang/String;

    move-result-object v3

    const/4 v5, 0x3

    sget-object v6, Lcn/uc/gamesdk/a/a;->a:Ljava/lang/String;

    invoke-static/range {v0 .. v6}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;ILjava/lang/String;)V
    :try_end_7
    .catchall {:try_start_7 .. :try_end_7} :catchall_0

    goto :goto_4

    :cond_8
    const/4 v0, 0x1

    :try_start_8
    iput-boolean v0, p0, Lcn/uc/gamesdk/b/a;->s:Z

    iget-object v0, p0, Lcn/uc/gamesdk/b/a;->p:Ljava/util/HashMap;
    :try_end_8
    .catch Ljava/lang/ClassNotFoundException; {:try_start_8 .. :try_end_8} :catch_0
    .catch Ljava/lang/IllegalAccessException; {:try_start_8 .. :try_end_8} :catch_1
    .catch Ljava/io/IOException; {:try_start_8 .. :try_end_8} :catch_2
    .catch Lorg/xmlpull/v1/XmlPullParserException; {:try_start_8 .. :try_end_8} :catch_3
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_8 .. :try_end_8} :catch_4
    .catch Ljava/lang/NoSuchMethodException; {:try_start_8 .. :try_end_8} :catch_5
    .catch Ljava/lang/Exception; {:try_start_8 .. :try_end_8} :catch_6
    .catchall {:try_start_8 .. :try_end_8} :catchall_0

    goto/16 :goto_0

    :catch_3
    move-exception v4

    :try_start_9
    const-string v0, "dexLoading"

    const-string v1, "A"

    const-string v2, "XmlPullParserException"

    const/4 v3, 0x1

    invoke-static {v0, v1, v2, v3}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)V

    const-string v0, "DexLoader"

    const-string v1, "creator"

    const-string v2, "resource"

    invoke-virtual {v4}, Lorg/xmlpull/v1/XmlPullParserException;->getMessage()Ljava/lang/String;

    move-result-object v3

    const/4 v5, 0x3

    sget-object v6, Lcn/uc/gamesdk/a/a;->a:Ljava/lang/String;

    invoke-static/range {v0 .. v6}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;ILjava/lang/String;)V

    goto/16 :goto_4

    :catch_4
    move-exception v4

    const-string v0, "dexLoading"

    const-string v1, "A"

    const-string v2, "\u5165\u53e3\u7c7b\u5b9e\u4f8b\u5316\u9519\u8bef,\u914d\u7f6e\u6587\u4ef6\u9519\u8bef\uff1f"

    const/4 v3, 0x1

    invoke-static {v0, v1, v2, v3}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)V

    const-string v0, "DexLoader"

    const-string v1, "creator"

    const-string v2, "resource"

    const-string v3, "\u5165\u53e3\u7c7b\u5b9e\u4f8b\u5316\u9519\u8bef,\u914d\u7f6e\u6587\u4ef6\u9519\u8bef\uff1f"

    const/4 v5, 0x2

    sget-object v6, Lcn/uc/gamesdk/a/a;->a:Ljava/lang/String;

    invoke-static/range {v0 .. v6}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;ILjava/lang/String;)V

    goto/16 :goto_4

    :catch_5
    move-exception v4

    const-string v0, "dexLoading"

    const-string v1, "A"

    const-string v2, "\u627e\u4e0d\u5230\u5165\u53e3\u5b9e\u4f8b\u65b9\u6cd5 getInstance() "

    const/4 v3, 0x1

    invoke-static {v0, v1, v2, v3}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)V

    const-string v0, "DexLoader"

    const-string v1, "creator"

    const-string v2, "INNER"

    const-string v3, "\u627e\u4e0d\u5230\u5165\u53e3\u5b9e\u4f8b\u65b9\u6cd5 getInstance() "

    const/4 v5, 0x2

    sget-object v6, Lcn/uc/gamesdk/a/a;->a:Ljava/lang/String;

    invoke-static/range {v0 .. v6}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;ILjava/lang/String;)V

    goto/16 :goto_4

    :catch_6
    move-exception v4

    const-string v0, "DexLoader"

    const-string v1, "creator"

    const-string v2, "unknown"

    const-string v3, ""

    const/4 v5, 0x2

    sget-object v6, Lcn/uc/gamesdk/a/a;->a:Ljava/lang/String;

    invoke-static/range {v0 .. v6}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;ILjava/lang/String;)V
    :try_end_9
    .catchall {:try_start_9 .. :try_end_9} :catchall_0

    goto/16 :goto_4
.end method
