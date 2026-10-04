.class public final Lcom/alipay/mobilesecuritysdk/model/d;
.super Ljava/lang/Object;


# instance fields
.field public a:Lcom/alipay/mobilesecuritysdk/datainfo/e;

.field private b:Landroid/content/Context;

.field private c:Lcom/alipay/mobilesecuritysdk/model/b;


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    new-instance v0, Lcom/alipay/mobilesecuritysdk/model/b;

    invoke-direct {v0}, Lcom/alipay/mobilesecuritysdk/model/b;-><init>()V

    iput-object v0, p0, Lcom/alipay/mobilesecuritysdk/model/d;->c:Lcom/alipay/mobilesecuritysdk/model/b;

    iput-object p1, p0, Lcom/alipay/mobilesecuritysdk/model/d;->b:Landroid/content/Context;

    return-void
.end method

.method private a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Lcom/alipay/mobilesecuritysdk/datainfo/b;
    .locals 4

    new-instance v0, Lcom/alipay/mobilesecuritysdk/datainfo/b;

    invoke-direct {v0}, Lcom/alipay/mobilesecuritysdk/datainfo/b;-><init>()V

    :try_start_0
    new-instance v1, LHttpUtils/a;

    invoke-direct {v1}, LHttpUtils/a;-><init>()V

    iget-object v1, p0, Lcom/alipay/mobilesecuritysdk/model/d;->b:Landroid/content/Context;

    const-string v1, "https://seccliprod.alipay.com/api/do.htm"

    const/4 v2, 0x1

    invoke-static {v1, p1, p2, p3, v2}, LHttpUtils/a;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)Lorg/apache/http/HttpResponse;

    move-result-object v1

    if-eqz v1, :cond_0

    invoke-interface {v1}, Lorg/apache/http/HttpResponse;->getStatusLine()Lorg/apache/http/StatusLine;

    move-result-object v2

    invoke-interface {v2}, Lorg/apache/http/StatusLine;->getStatusCode()I

    move-result v2

    const/16 v3, 0xc8

    if-ne v2, v3, :cond_0

    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/model/d;->c:Lcom/alipay/mobilesecuritysdk/model/b;

    invoke-interface {v1}, Lorg/apache/http/HttpResponse;->getEntity()Lorg/apache/http/HttpEntity;

    move-result-object v1

    invoke-static {v1}, Lorg/apache/http/util/EntityUtils;->toString(Lorg/apache/http/HttpEntity;)Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/alipay/mobilesecuritysdk/model/b;->b(Ljava/lang/String;)Lcom/alipay/mobilesecuritysdk/datainfo/b;

    move-result-object v0

    :goto_0
    return-object v0

    :cond_0
    const/4 v1, 0x0

    iput-boolean v1, v0, Lcom/alipay/mobilesecuritysdk/datainfo/b;->a:Z
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v1

    const-string v2, "upload data  error"

    invoke-virtual {v1}, Ljava/io/IOException;->getLocalizedMessage()Ljava/lang/String;

    move-result-object v1

    invoke-static {v2, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0
.end method

.method private a(Lcom/alipay/mobilesecuritysdk/datainfo/e;)V
    .locals 0

    iput-object p1, p0, Lcom/alipay/mobilesecuritysdk/model/d;->a:Lcom/alipay/mobilesecuritysdk/datainfo/e;

    return-void
.end method

.method private b()Lcom/alipay/mobilesecuritysdk/datainfo/e;
    .locals 1

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/model/d;->a:Lcom/alipay/mobilesecuritysdk/datainfo/e;

    return-object v0
.end method


# virtual methods
.method public final a()Lcom/alipay/mobilesecuritysdk/datainfo/b;
    .locals 5

    const/4 v4, 0x0

    new-instance v0, Lcom/alipay/mobilesecuritysdk/datainfo/b;

    invoke-direct {v0}, Lcom/alipay/mobilesecuritysdk/datainfo/b;-><init>()V

    iget-object v1, p0, Lcom/alipay/mobilesecuritysdk/model/d;->b:Landroid/content/Context;

    invoke-static {v1}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Landroid/content/Context;)Z

    move-result v1

    if-nez v1, :cond_0

    :goto_0
    return-object v0

    :cond_0
    :try_start_0
    new-instance v1, Lorg/apache/http/client/methods/HttpGet;

    const-string v2, "http://secclientgw.alipay.com/mobile/switch.xml"

    invoke-direct {v1, v2}, Lorg/apache/http/client/methods/HttpGet;-><init>(Ljava/lang/String;)V

    new-instance v2, LHttpUtils/a;

    invoke-direct {v2}, LHttpUtils/a;-><init>()V

    invoke-static {}, LHttpUtils/a;->a()Lorg/apache/http/client/HttpClient;

    move-result-object v2

    invoke-interface {v2, v1}, Lorg/apache/http/client/HttpClient;->execute(Lorg/apache/http/client/methods/HttpUriRequest;)Lorg/apache/http/HttpResponse;

    move-result-object v1

    invoke-interface {v1}, Lorg/apache/http/HttpResponse;->getStatusLine()Lorg/apache/http/StatusLine;

    move-result-object v2

    invoke-interface {v2}, Lorg/apache/http/StatusLine;->getStatusCode()I

    move-result v2

    const/16 v3, 0xc8

    if-ne v2, v3, :cond_1

    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/model/d;->c:Lcom/alipay/mobilesecuritysdk/model/b;

    invoke-interface {v1}, Lorg/apache/http/HttpResponse;->getEntity()Lorg/apache/http/HttpEntity;

    move-result-object v1

    invoke-static {v1}, Lorg/apache/http/util/EntityUtils;->toString(Lorg/apache/http/HttpEntity;)Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/alipay/mobilesecuritysdk/model/b;->b(Ljava/lang/String;)Lcom/alipay/mobilesecuritysdk/datainfo/b;

    move-result-object v0

    goto :goto_0

    :cond_1
    const/4 v1, 0x0

    iput-boolean v1, v0, Lcom/alipay/mobilesecuritysdk/datainfo/b;->a:Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v1

    iput-boolean v4, v0, Lcom/alipay/mobilesecuritysdk/datainfo/b;->a:Z

    goto :goto_0
.end method

.method public final a(Ljava/util/List;)Lcom/alipay/mobilesecuritysdk/datainfo/b;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List",
            "<",
            "Ljava/lang/String;",
            ">;)",
            "Lcom/alipay/mobilesecuritysdk/datainfo/b;"
        }
    .end annotation

    new-instance v0, Lcom/alipay/mobilesecuritysdk/datainfo/b;

    invoke-direct {v0}, Lcom/alipay/mobilesecuritysdk/datainfo/b;-><init>()V

    invoke-static {p1}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/util/List;)Z

    move-result v1

    if-eqz v1, :cond_1

    const/4 v1, 0x0

    iput-boolean v1, v0, Lcom/alipay/mobilesecuritysdk/datainfo/b;->a:Z

    :cond_0
    :goto_0
    return-object v0

    :cond_1
    iget-object v1, p0, Lcom/alipay/mobilesecuritysdk/model/d;->a:Lcom/alipay/mobilesecuritysdk/datainfo/e;

    iget-object v1, v1, Lcom/alipay/mobilesecuritysdk/datainfo/e;->b:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    if-lez v1, :cond_4

    iget-object v1, p0, Lcom/alipay/mobilesecuritysdk/model/d;->c:Lcom/alipay/mobilesecuritysdk/model/b;

    iput-object p1, v1, Lcom/alipay/mobilesecuritysdk/model/b;->a:Ljava/util/List;

    iget-object v1, p0, Lcom/alipay/mobilesecuritysdk/model/d;->c:Lcom/alipay/mobilesecuritysdk/model/b;

    new-instance v2, Ljava/lang/StringBuilder;

    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/model/d;->b:Landroid/content/Context;

    invoke-virtual {v3}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v3

    invoke-virtual {v3}, Ljava/io/File;->getPath()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object v3, Ljava/io/File;->separator:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "appupload.xml"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/model/d;->a:Lcom/alipay/mobilesecuritysdk/datainfo/e;

    iget-object v3, v3, Lcom/alipay/mobilesecuritysdk/datainfo/e;->b:Ljava/util/List;

    invoke-virtual {v1, v2, v3}, Lcom/alipay/mobilesecuritysdk/model/b;->a(Ljava/lang/String;Ljava/util/List;)Ljava/lang/String;

    move-result-object v1

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/face/SecurityClientMobile;->isDebug()Z

    move-result v2

    if-eqz v2, :cond_2

    const-string v2, "str app info"

    invoke-static {v2, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    :cond_2
    if-eqz v1, :cond_3

    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v2

    if-lez v2, :cond_3

    const-string v0, "mobileClient"

    const-string v2, "1"

    invoke-direct {p0, v0, v1, v2}, Lcom/alipay/mobilesecuritysdk/model/d;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Lcom/alipay/mobilesecuritysdk/datainfo/b;

    move-result-object v0

    :cond_3
    iget-boolean v2, v0, Lcom/alipay/mobilesecuritysdk/datainfo/b;->a:Z

    if-nez v2, :cond_7

    :try_start_0
    new-instance v2, Ljava/lang/StringBuilder;

    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/model/d;->b:Landroid/content/Context;

    invoke-virtual {v3}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v3

    invoke-virtual {v3}, Ljava/io/File;->getPath()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object v3, Ljava/io/File;->separator:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "appupload.xml"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2, v1}, Lcom/alipay/mobilesecuritysdk/util/a;->b(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_1

    :cond_4
    :goto_1
    iget-object v1, p0, Lcom/alipay/mobilesecuritysdk/model/d;->a:Lcom/alipay/mobilesecuritysdk/datainfo/e;

    iget-object v1, v1, Lcom/alipay/mobilesecuritysdk/datainfo/e;->a:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    if-lez v1, :cond_0

    iget-object v1, p0, Lcom/alipay/mobilesecuritysdk/model/d;->c:Lcom/alipay/mobilesecuritysdk/model/b;

    iput-object p1, v1, Lcom/alipay/mobilesecuritysdk/model/b;->a:Ljava/util/List;

    iget-object v1, p0, Lcom/alipay/mobilesecuritysdk/model/d;->c:Lcom/alipay/mobilesecuritysdk/model/b;

    new-instance v2, Ljava/lang/StringBuilder;

    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/model/d;->b:Landroid/content/Context;

    invoke-virtual {v3}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v3

    invoke-virtual {v3}, Ljava/io/File;->getPath()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object v3, Ljava/io/File;->separator:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "locationupload.xml"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/model/d;->a:Lcom/alipay/mobilesecuritysdk/datainfo/e;

    iget-object v3, v3, Lcom/alipay/mobilesecuritysdk/datainfo/e;->a:Ljava/util/List;

    invoke-virtual {v1, v2, v3}, Lcom/alipay/mobilesecuritysdk/model/b;->b(Ljava/lang/String;Ljava/util/List;)Ljava/lang/String;

    move-result-object v1

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/face/SecurityClientMobile;->isDebug()Z

    move-result v2

    if-eqz v2, :cond_5

    const-string v2, "str aloc info"

    invoke-static {v2, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    :cond_5
    if-eqz v1, :cond_6

    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v2

    if-lez v2, :cond_6

    const-string v0, "mobileClient"

    const-string v2, "1"

    invoke-direct {p0, v0, v1, v2}, Lcom/alipay/mobilesecuritysdk/model/d;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Lcom/alipay/mobilesecuritysdk/datainfo/b;

    move-result-object v0

    :cond_6
    iget-boolean v2, v0, Lcom/alipay/mobilesecuritysdk/datainfo/b;->a:Z

    if-nez v2, :cond_8

    :try_start_1
    new-instance v2, Ljava/lang/StringBuilder;

    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/model/d;->b:Landroid/content/Context;

    invoke-virtual {v3}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v3

    invoke-virtual {v3}, Ljava/io/File;->getPath()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object v3, Ljava/io/File;->separator:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "locationupload.xml"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2, v1}, Lcom/alipay/mobilesecuritysdk/util/a;->b(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0

    goto/16 :goto_0

    :catch_0
    move-exception v1

    const-string v2, "location write file"

    invoke-virtual {v1}, Ljava/io/IOException;->getLocalizedMessage()Ljava/lang/String;

    move-result-object v1

    invoke-static {v2, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto/16 :goto_0

    :catch_1
    move-exception v1

    const-string v2, "app write file"

    invoke-virtual {v1}, Ljava/io/IOException;->getLocalizedMessage()Ljava/lang/String;

    move-result-object v1

    invoke-static {v2, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto/16 :goto_1

    :cond_7
    iget-object v1, p0, Lcom/alipay/mobilesecuritysdk/model/d;->c:Lcom/alipay/mobilesecuritysdk/model/b;

    new-instance v1, Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/model/d;->b:Landroid/content/Context;

    invoke-virtual {v2}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v2

    invoke-virtual {v2}, Ljava/io/File;->getPath()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object v2, Ljava/io/File;->separator:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "appupload.xml"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/alipay/mobilesecuritysdk/model/b;->c(Ljava/lang/String;)V

    const-string v1, "app write file"

    const-string v2, "upload  suceess  delete file"

    invoke-static {v1, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto/16 :goto_1

    :cond_8
    iget-object v1, p0, Lcom/alipay/mobilesecuritysdk/model/d;->c:Lcom/alipay/mobilesecuritysdk/model/b;

    new-instance v1, Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/model/d;->b:Landroid/content/Context;

    invoke-virtual {v2}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v2

    invoke-virtual {v2}, Ljava/io/File;->getPath()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object v2, Ljava/io/File;->separator:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "locationupload.xml"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/alipay/mobilesecuritysdk/model/b;->c(Ljava/lang/String;)V

    const-string v1, "location write file"

    const-string v2, "upload  suceess  delete file"

    invoke-static {v1, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto/16 :goto_0
.end method
