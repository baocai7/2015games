.class public final Lcom/alipay/mobilesecuritysdk/model/b;
.super Ljava/lang/Object;


# instance fields
.field a:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List",
            "<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static a(Ljava/lang/String;)Lcom/alipay/mobilesecuritysdk/datainfo/d;
    .locals 4

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    if-eqz v0, :cond_3

    :try_start_0
    new-instance v0, Ljava/io/File;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-static {p0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object v2, Ljava/io/File;->separator:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "seccliconfig.xml"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/io/File;->exists()Z

    move-result v1

    if-nez v1, :cond_0

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/model/b;->b()Lcom/alipay/mobilesecuritysdk/datainfo/d;

    move-result-object v0

    :goto_0
    return-object v0

    :cond_0
    invoke-virtual {v0}, Ljava/io/File;->getPath()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->d(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v0

    if-gtz v0, :cond_1

    const-string v0, "read json"

    const-string v1, "file size o"

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/model/b;->b()Lcom/alipay/mobilesecuritysdk/datainfo/d;

    move-result-object v0

    goto :goto_0

    :cond_1
    invoke-static {}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->a()Lcom/alipay/mobilesecuritysdk/datainfo/d;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_1

    move-result-object v0

    :try_start_1
    new-instance v2, Lorg/json/JSONObject;

    invoke-direct {v2, v1}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    const-string v1, "configs"

    invoke-virtual {v2, v1}, Lorg/json/JSONObject;->getJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v1

    if-nez v1, :cond_2

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/model/b;->b()Lcom/alipay/mobilesecuritysdk/datainfo/d;

    move-result-object v0

    goto :goto_0

    :cond_2
    sget-object v2, Lcom/alipay/mobilesecuritysdk/constant/b;->g:Lcom/alipay/mobilesecuritysdk/constant/b;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/constant/b;->a()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v2

    invoke-virtual {v0, v2}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->c(I)V

    sget-object v2, Lcom/alipay/mobilesecuritysdk/constant/b;->f:Lcom/alipay/mobilesecuritysdk/constant/b;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/constant/b;->a()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Lorg/json/JSONObject;->getLong(Ljava/lang/String;)J

    move-result-wide v2

    invoke-virtual {v0, v2, v3}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->c(J)V

    sget-object v2, Lcom/alipay/mobilesecuritysdk/constant/b;->e:Lcom/alipay/mobilesecuritysdk/constant/b;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/constant/b;->a()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v2

    invoke-virtual {v0, v2}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->b(I)V

    sget-object v2, Lcom/alipay/mobilesecuritysdk/constant/b;->d:Lcom/alipay/mobilesecuritysdk/constant/b;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/constant/b;->a()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Lorg/json/JSONObject;->getLong(Ljava/lang/String;)J

    move-result-wide v2

    invoke-virtual {v0, v2, v3}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->b(J)V

    sget-object v2, Lcom/alipay/mobilesecuritysdk/constant/b;->i:Lcom/alipay/mobilesecuritysdk/constant/b;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/constant/b;->a()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v2

    invoke-virtual {v0, v2}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->d(I)V

    sget-object v2, Lcom/alipay/mobilesecuritysdk/constant/b;->c:Lcom/alipay/mobilesecuritysdk/constant/b;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/constant/b;->a()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v2

    invoke-virtual {v0, v2}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->a(I)V

    sget-object v2, Lcom/alipay/mobilesecuritysdk/constant/b;->a:Lcom/alipay/mobilesecuritysdk/constant/b;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/constant/b;->a()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Lorg/json/JSONObject;->getLong(Ljava/lang/String;)J

    move-result-wide v2

    invoke-virtual {v0, v2, v3}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->a(J)V

    sget-object v2, Lcom/alipay/mobilesecuritysdk/constant/b;->b:Lcom/alipay/mobilesecuritysdk/constant/b;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/constant/b;->a()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->a(Ljava/lang/String;)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    goto/16 :goto_0

    :catch_0
    move-exception v0

    :try_start_2
    invoke-static {}, Lcom/alipay/mobilesecuritysdk/model/b;->b()Lcom/alipay/mobilesecuritysdk/datainfo/d;
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_1

    move-result-object v0

    goto/16 :goto_0

    :catch_1
    move-exception v0

    const/4 v0, 0x1

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/face/SecurityClientMobile;->setError(Z)V

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/model/b;->b()Lcom/alipay/mobilesecuritysdk/datainfo/d;

    move-result-object v0

    goto/16 :goto_0

    :cond_3
    const/4 v0, 0x0

    goto/16 :goto_0
.end method

.method private a()Ljava/util/List;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List",
            "<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/model/b;->a:Ljava/util/List;

    return-object v0
.end method

.method public static a(Lcom/alipay/mobilesecuritysdk/datainfo/d;Ljava/lang/String;)V
    .locals 4

    :try_start_0
    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V

    sget-object v1, Lcom/alipay/mobilesecuritysdk/constant/b;->a:Lcom/alipay/mobilesecuritysdk/constant/b;

    invoke-virtual {v1}, Lcom/alipay/mobilesecuritysdk/constant/b;->a()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->b()J

    move-result-wide v2

    invoke-virtual {v0, v1, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;J)Lorg/json/JSONObject;

    sget-object v1, Lcom/alipay/mobilesecuritysdk/constant/b;->b:Lcom/alipay/mobilesecuritysdk/constant/b;

    invoke-virtual {v1}, Lcom/alipay/mobilesecuritysdk/constant/b;->a()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->c()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    sget-object v1, Lcom/alipay/mobilesecuritysdk/constant/b;->c:Lcom/alipay/mobilesecuritysdk/constant/b;

    invoke-virtual {v1}, Lcom/alipay/mobilesecuritysdk/constant/b;->a()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->d()I

    move-result v2

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    sget-object v1, Lcom/alipay/mobilesecuritysdk/constant/b;->d:Lcom/alipay/mobilesecuritysdk/constant/b;

    invoke-virtual {v1}, Lcom/alipay/mobilesecuritysdk/constant/b;->a()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->e()J

    move-result-wide v2

    invoke-virtual {v0, v1, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;J)Lorg/json/JSONObject;

    sget-object v1, Lcom/alipay/mobilesecuritysdk/constant/b;->e:Lcom/alipay/mobilesecuritysdk/constant/b;

    invoke-virtual {v1}, Lcom/alipay/mobilesecuritysdk/constant/b;->a()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->f()I

    move-result v2

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    sget-object v1, Lcom/alipay/mobilesecuritysdk/constant/b;->i:Lcom/alipay/mobilesecuritysdk/constant/b;

    invoke-virtual {v1}, Lcom/alipay/mobilesecuritysdk/constant/b;->a()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->i()I

    move-result v2

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    sget-object v1, Lcom/alipay/mobilesecuritysdk/constant/b;->f:Lcom/alipay/mobilesecuritysdk/constant/b;

    invoke-virtual {v1}, Lcom/alipay/mobilesecuritysdk/constant/b;->a()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->g()J

    move-result-wide v2

    invoke-virtual {v0, v1, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;J)Lorg/json/JSONObject;

    sget-object v1, Lcom/alipay/mobilesecuritysdk/constant/b;->g:Lcom/alipay/mobilesecuritysdk/constant/b;

    invoke-virtual {v1}, Lcom/alipay/mobilesecuritysdk/constant/b;->a()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->h()I

    move-result v2

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1}, Lorg/json/JSONObject;-><init>()V

    sget-object v2, Lcom/alipay/mobilesecuritysdk/constant/b;->j:Lcom/alipay/mobilesecuritysdk/constant/b;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/constant/b;->a()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/face/SecurityClientMobile;->isDebug()Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v0, "ALP"

    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "loadConfig"

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    :cond_0
    invoke-virtual {v1}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {p1, v0}, Lcom/alipay/mobilesecuritysdk/util/a;->b(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :goto_0
    return-void

    :catch_0
    move-exception v0

    const/4 v0, 0x1

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/face/SecurityClientMobile;->setError(Z)V

    goto :goto_0
.end method

.method private a(Ljava/util/List;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List",
            "<",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    iput-object p1, p0, Lcom/alipay/mobilesecuritysdk/model/b;->a:Ljava/util/List;

    return-void
.end method

.method public static b(Ljava/lang/String;)Lcom/alipay/mobilesecuritysdk/datainfo/b;
    .locals 6

    const/4 v5, 0x1

    new-instance v1, Lcom/alipay/mobilesecuritysdk/datainfo/b;

    invoke-direct {v1}, Lcom/alipay/mobilesecuritysdk/datainfo/b;-><init>()V

    :try_start_0
    invoke-static {}, Lorg/xmlpull/v1/XmlPullParserFactory;->newInstance()Lorg/xmlpull/v1/XmlPullParserFactory;

    move-result-object v0

    invoke-virtual {v0}, Lorg/xmlpull/v1/XmlPullParserFactory;->newPullParser()Lorg/xmlpull/v1/XmlPullParser;

    move-result-object v2

    new-instance v0, Ljava/io/StringReader;

    invoke-direct {v0, p0}, Ljava/io/StringReader;-><init>(Ljava/lang/String;)V

    invoke-interface {v2, v0}, Lorg/xmlpull/v1/XmlPullParser;->setInput(Ljava/io/Reader;)V

    invoke-interface {v2}, Lorg/xmlpull/v1/XmlPullParser;->getEventType()I
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_1

    move-result v0

    :goto_0
    if-ne v0, v5, :cond_0

    :goto_1
    iput-boolean v5, v1, Lcom/alipay/mobilesecuritysdk/datainfo/b;->a:Z

    return-object v1

    :cond_0
    :try_start_1
    invoke-interface {v2}, Lorg/xmlpull/v1/XmlPullParser;->getName()Ljava/lang/String;

    move-result-object v3

    const/4 v4, 0x2

    if-ne v0, v4, :cond_1

    sget-object v0, Lcom/alipay/mobilesecuritysdk/constant/b;->b:Lcom/alipay/mobilesecuritysdk/constant/b;

    invoke-virtual {v0}, Lcom/alipay/mobilesecuritysdk/constant/b;->a()Ljava/lang/String;

    move-result-object v0

    invoke-static {v3, v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_2

    invoke-interface {v2}, Lorg/xmlpull/v1/XmlPullParser;->nextText()Ljava/lang/String;

    move-result-object v0

    iput-object v0, v1, Lcom/alipay/mobilesecuritysdk/datainfo/b;->b:Ljava/lang/String;

    :cond_1
    :goto_2
    invoke-interface {v2}, Lorg/xmlpull/v1/XmlPullParser;->next()I

    move-result v0

    goto :goto_0

    :cond_2
    sget-object v0, Lcom/alipay/mobilesecuritysdk/constant/b;->c:Lcom/alipay/mobilesecuritysdk/constant/b;

    invoke-virtual {v0}, Lcom/alipay/mobilesecuritysdk/constant/b;->a()Ljava/lang/String;

    move-result-object v0

    invoke-static {v3, v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_3

    invoke-interface {v2}, Lorg/xmlpull/v1/XmlPullParser;->nextText()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->b(Ljava/lang/String;)I

    move-result v0

    iput v0, v1, Lcom/alipay/mobilesecuritysdk/datainfo/b;->c:I

    goto :goto_2

    :catch_0
    move-exception v0

    goto :goto_1

    :cond_3
    sget-object v0, Lcom/alipay/mobilesecuritysdk/constant/b;->e:Lcom/alipay/mobilesecuritysdk/constant/b;

    invoke-virtual {v0}, Lcom/alipay/mobilesecuritysdk/constant/b;->a()Ljava/lang/String;

    move-result-object v0

    invoke-static {v3, v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_4

    invoke-interface {v2}, Lorg/xmlpull/v1/XmlPullParser;->nextText()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->b(Ljava/lang/String;)I

    move-result v0

    iput v0, v1, Lcom/alipay/mobilesecuritysdk/datainfo/b;->d:I

    goto :goto_2

    :cond_4
    sget-object v0, Lcom/alipay/mobilesecuritysdk/constant/b;->i:Lcom/alipay/mobilesecuritysdk/constant/b;

    invoke-virtual {v0}, Lcom/alipay/mobilesecuritysdk/constant/b;->a()Ljava/lang/String;

    move-result-object v0

    invoke-static {v3, v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_5

    invoke-interface {v2}, Lorg/xmlpull/v1/XmlPullParser;->nextText()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->b(Ljava/lang/String;)I

    move-result v0

    iput v0, v1, Lcom/alipay/mobilesecuritysdk/datainfo/b;->f:I

    goto :goto_2

    :cond_5
    sget-object v0, Lcom/alipay/mobilesecuritysdk/constant/b;->g:Lcom/alipay/mobilesecuritysdk/constant/b;

    invoke-virtual {v0}, Lcom/alipay/mobilesecuritysdk/constant/b;->a()Ljava/lang/String;

    move-result-object v0

    invoke-static {v3, v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-interface {v2}, Lorg/xmlpull/v1/XmlPullParser;->nextText()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->b(Ljava/lang/String;)I

    move-result v0

    iput v0, v1, Lcom/alipay/mobilesecuritysdk/datainfo/b;->e:I
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_2

    :catch_1
    move-exception v0

    const-string v2, "ALP"

    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v0

    invoke-static {v2, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto/16 :goto_1
.end method

.method private static b()Lcom/alipay/mobilesecuritysdk/datainfo/d;
    .locals 4

    const-wide/16 v2, 0x0

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->a()Lcom/alipay/mobilesecuritysdk/datainfo/d;

    move-result-object v0

    invoke-virtual {v0, v2, v3}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->a(J)V

    const-string v1, "on"

    invoke-virtual {v0, v1}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->a(Ljava/lang/String;)V

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->a(I)V

    invoke-virtual {v0, v2, v3}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->b(J)V

    const/16 v1, 0x1e

    invoke-virtual {v0, v1}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->b(I)V

    const/16 v1, 0x18

    invoke-virtual {v0, v1}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->d(I)V

    invoke-virtual {v0, v2, v3}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->c(J)V

    const/4 v1, 0x7

    invoke-virtual {v0, v1}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->c(I)V

    return-object v0
.end method

.method private static b(Ljava/util/List;)Lorg/json/JSONArray;
    .locals 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List",
            "<",
            "Lcom/alipay/mobilesecuritysdk/datainfo/f;",
            ">;)",
            "Lorg/json/JSONArray;"
        }
    .end annotation

    new-instance v1, Lorg/json/JSONArray;

    invoke-direct {v1}, Lorg/json/JSONArray;-><init>()V

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :goto_0
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-nez v0, :cond_0

    return-object v1

    :cond_0
    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/alipay/mobilesecuritysdk/datainfo/f;

    :try_start_0
    new-instance v3, Lorg/json/JSONObject;

    invoke-direct {v3}, Lorg/json/JSONObject;-><init>()V

    iget-object v4, v0, Lcom/alipay/mobilesecuritysdk/datainfo/f;->a:Ljava/lang/String;

    if-nez v4, :cond_1

    sget-object v4, Lcom/alipay/mobilesecuritysdk/constant/c;->n:Lcom/alipay/mobilesecuritysdk/constant/c;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/constant/c;->a()Ljava/lang/String;

    move-result-object v4

    const-string v5, ""

    invoke-virtual {v3, v4, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    :goto_1
    iget-object v4, v0, Lcom/alipay/mobilesecuritysdk/datainfo/f;->c:Ljava/lang/String;

    if-nez v4, :cond_2

    sget-object v4, Lcom/alipay/mobilesecuritysdk/constant/c;->o:Lcom/alipay/mobilesecuritysdk/constant/c;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/constant/c;->a()Ljava/lang/String;

    move-result-object v4

    const-string v5, ""

    invoke-virtual {v3, v4, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    :goto_2
    sget-object v4, Lcom/alipay/mobilesecuritysdk/constant/c;->q:Lcom/alipay/mobilesecuritysdk/constant/c;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/constant/c;->a()Ljava/lang/String;

    move-result-object v4

    iget-boolean v5, v0, Lcom/alipay/mobilesecuritysdk/datainfo/f;->d:Z

    invoke-virtual {v3, v4, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    sget-object v4, Lcom/alipay/mobilesecuritysdk/constant/c;->p:Lcom/alipay/mobilesecuritysdk/constant/c;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/constant/c;->a()Ljava/lang/String;

    move-result-object v4

    iget v0, v0, Lcom/alipay/mobilesecuritysdk/datainfo/f;->b:I

    invoke-virtual {v3, v4, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    invoke-virtual {v1, v3}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;
    :try_end_0
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    const-string v3, "location"

    invoke-virtual {v0}, Lorg/json/JSONException;->getLocalizedMessage()Ljava/lang/String;

    move-result-object v0

    invoke-static {v3, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    :cond_1
    :try_start_1
    sget-object v4, Lcom/alipay/mobilesecuritysdk/constant/c;->n:Lcom/alipay/mobilesecuritysdk/constant/c;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/constant/c;->a()Ljava/lang/String;

    move-result-object v4

    iget-object v5, v0, Lcom/alipay/mobilesecuritysdk/datainfo/f;->a:Ljava/lang/String;

    invoke-virtual {v3, v4, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    goto :goto_1

    :cond_2
    sget-object v4, Lcom/alipay/mobilesecuritysdk/constant/c;->o:Lcom/alipay/mobilesecuritysdk/constant/c;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/constant/c;->a()Ljava/lang/String;

    move-result-object v4

    iget-object v5, v0, Lcom/alipay/mobilesecuritysdk/datainfo/f;->c:Ljava/lang/String;

    invoke-virtual {v3, v4, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_1
    .catch Lorg/json/JSONException; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_2
.end method

.method private c()Lorg/json/JSONArray;
    .locals 3

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/model/b;->a:Ljava/util/List;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/model/b;->a:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_1

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return-object v0

    :cond_1
    new-instance v1, Lorg/json/JSONArray;

    invoke-direct {v1}, Lorg/json/JSONArray;-><init>()V

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/model/b;->a:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :goto_1
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-nez v0, :cond_2

    move-object v0, v1

    goto :goto_0

    :cond_2
    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-virtual {v1, v0}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;

    goto :goto_1
.end method

.method public static c(Ljava/lang/String;)V
    .locals 2

    :try_start_0
    new-instance v0, Ljava/io/File;

    invoke-direct {v0, p0}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/io/File;->exists()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-virtual {v0}, Ljava/io/File;->delete()Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :cond_0
    :goto_0
    return-void

    :catch_0
    move-exception v0

    const-string v1, "ALP"

    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0
.end method

.method private static d(Ljava/lang/String;)Lorg/json/JSONArray;
    .locals 3

    const/4 v1, 0x0

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    if-lez v0, :cond_0

    invoke-static {p0}, Lcom/alipay/mobilesecuritysdk/util/a;->d(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v0

    if-gtz v0, :cond_1

    :cond_0
    :goto_0
    return-object v1

    :cond_1
    :try_start_0
    new-instance v0, Lorg/json/JSONArray;

    invoke-direct {v0, v2}, Lorg/json/JSONArray;-><init>(Ljava/lang/String;)V
    :try_end_0
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_0

    :goto_1
    move-object v1, v0

    goto :goto_0

    :catch_0
    move-exception v0

    const-string v2, "getjsonfromfile"

    invoke-virtual {v0}, Lorg/json/JSONException;->getLocalizedMessage()Ljava/lang/String;

    move-result-object v0

    invoke-static {v2, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    move-object v0, v1

    goto :goto_1
.end method


# virtual methods
.method public final a(Ljava/lang/String;Ljava/util/List;)Ljava/lang/String;
    .locals 9
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "Ljava/util/List",
            "<",
            "Lcom/alipay/mobilesecuritysdk/datainfo/a;",
            ">;)",
            "Ljava/lang/String;"
        }
    .end annotation

    new-instance v0, Ljava/io/File;

    invoke-direct {v0, p1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/io/File;->length()J

    move-result-wide v1

    const-wide/32 v3, 0xc800

    cmp-long v1, v1, v3

    if-lez v1, :cond_0

    invoke-virtual {v0}, Ljava/io/File;->delete()Z

    const-string v0, "delete file"

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "app file size > 50k, file path is"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    :cond_0
    new-instance v1, Lorg/json/JSONArray;

    invoke-direct {v1}, Lorg/json/JSONArray;-><init>()V

    new-instance v2, Lorg/json/JSONObject;

    invoke-direct {v2}, Lorg/json/JSONObject;-><init>()V

    new-instance v3, Lorg/json/JSONObject;

    invoke-direct {v3}, Lorg/json/JSONObject;-><init>()V

    new-instance v4, Lorg/json/JSONArray;

    invoke-direct {v4}, Lorg/json/JSONArray;-><init>()V

    invoke-interface {p2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v5

    :goto_0
    invoke-interface {v5}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-nez v0, :cond_1

    :try_start_0
    invoke-direct {p0}, Lcom/alipay/mobilesecuritysdk/model/b;->c()Lorg/json/JSONArray;

    move-result-object v0

    if-nez v0, :cond_2

    const-string v0, "tid"

    const-string v5, ""

    invoke-virtual {v3, v0, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    :goto_1
    const-string v0, "appList"

    invoke-virtual {v3, v0, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string v0, "timestamp"

    new-instance v4, Ljava/util/Date;

    invoke-direct {v4}, Ljava/util/Date;-><init>()V

    invoke-static {v4}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v0, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string v0, "type"

    sget-object v4, Lcom/alipay/mobilesecuritysdk/constant/b;->n:Lcom/alipay/mobilesecuritysdk/constant/b;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/constant/b;->a()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v2, v0, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string v0, "model"

    invoke-virtual {v2, v0, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_0
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_1

    :goto_2
    invoke-virtual {v1, v2}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;

    invoke-virtual {v1}, Lorg/json/JSONArray;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0

    :cond_1
    invoke-interface {v5}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/alipay/mobilesecuritysdk/datainfo/a;

    :try_start_1
    new-instance v6, Lorg/json/JSONObject;

    invoke-direct {v6}, Lorg/json/JSONObject;-><init>()V

    sget-object v7, Lcom/alipay/mobilesecuritysdk/constant/b;->k:Lcom/alipay/mobilesecuritysdk/constant/b;

    invoke-virtual {v7}, Lcom/alipay/mobilesecuritysdk/constant/b;->a()Ljava/lang/String;

    move-result-object v7

    iget-object v8, v0, Lcom/alipay/mobilesecuritysdk/datainfo/a;->a:Ljava/lang/String;

    invoke-virtual {v6, v7, v8}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    sget-object v7, Lcom/alipay/mobilesecuritysdk/constant/b;->l:Lcom/alipay/mobilesecuritysdk/constant/b;

    invoke-virtual {v7}, Lcom/alipay/mobilesecuritysdk/constant/b;->a()Ljava/lang/String;

    move-result-object v7

    iget-object v0, v0, Lcom/alipay/mobilesecuritysdk/datainfo/a;->b:Ljava/lang/String;

    invoke-virtual {v6, v7, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    invoke-virtual {v4, v6}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;
    :try_end_1
    .catch Lorg/json/JSONException; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    const-string v6, "appinfo"

    invoke-virtual {v0}, Lorg/json/JSONException;->getLocalizedMessage()Ljava/lang/String;

    move-result-object v0

    invoke-static {v6, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    :cond_2
    :try_start_2
    const-string v0, "tid"

    invoke-direct {p0}, Lcom/alipay/mobilesecuritysdk/model/b;->c()Lorg/json/JSONArray;

    move-result-object v5

    invoke-virtual {v3, v0, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_2
    .catch Lorg/json/JSONException; {:try_start_2 .. :try_end_2} :catch_1

    goto :goto_1

    :catch_1
    move-exception v0

    const-string v3, "apptojason"

    invoke-virtual {v0}, Lorg/json/JSONException;->getLocalizedMessage()Ljava/lang/String;

    move-result-object v0

    invoke-static {v3, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_2
.end method

.method public final b(Ljava/lang/String;Ljava/util/List;)Ljava/lang/String;
    .locals 8
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "Ljava/util/List",
            "<",
            "Lcom/alipay/mobilesecuritysdk/datainfo/c;",
            ">;)",
            "Ljava/lang/String;"
        }
    .end annotation

    const/4 v2, 0x0

    const-string v0, "LocationToString path is "

    invoke-static {v0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    new-instance v0, Ljava/io/File;

    invoke-direct {v0, p1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/io/File;->length()J

    move-result-wide v3

    const-wide/32 v5, 0xc800

    cmp-long v1, v3, v5

    if-lez v1, :cond_0

    invoke-virtual {v0}, Ljava/io/File;->delete()Z

    const-string v0, "delete file"

    const-string v1, "lc file size > 50k"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    move-object v0, v2

    :goto_0
    if-nez v0, :cond_4

    new-instance v0, Lorg/json/JSONArray;

    invoke-direct {v0}, Lorg/json/JSONArray;-><init>()V

    move-object v1, v0

    :goto_1
    new-instance v3, Lorg/json/JSONObject;

    invoke-direct {v3}, Lorg/json/JSONObject;-><init>()V

    invoke-interface {p2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v4

    :goto_2
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-nez v0, :cond_1

    invoke-virtual {v1, v3}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;

    invoke-virtual {v1}, Lorg/json/JSONArray;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0

    :cond_0
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v1

    if-lez v1, :cond_5

    invoke-virtual {v0}, Ljava/io/File;->isDirectory()Z

    move-result v1

    if-nez v1, :cond_5

    invoke-virtual {v0}, Ljava/io/File;->exists()Z

    move-result v0

    if-eqz v0, :cond_5

    invoke-static {p1}, Lcom/alipay/mobilesecuritysdk/model/b;->d(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v0

    goto :goto_0

    :cond_1
    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/alipay/mobilesecuritysdk/datainfo/c;

    :try_start_0
    new-instance v5, Lorg/json/JSONObject;

    invoke-direct {v5}, Lorg/json/JSONObject;-><init>()V

    sget-object v6, Lcom/alipay/mobilesecuritysdk/constant/c;->a:Lcom/alipay/mobilesecuritysdk/constant/c;

    invoke-virtual {v6}, Lcom/alipay/mobilesecuritysdk/constant/c;->a()Ljava/lang/String;

    move-result-object v6

    iget-object v7, v0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->d:Ljava/lang/String;

    invoke-virtual {v5, v6, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    sget-object v6, Lcom/alipay/mobilesecuritysdk/constant/c;->b:Lcom/alipay/mobilesecuritysdk/constant/c;

    invoke-virtual {v6}, Lcom/alipay/mobilesecuritysdk/constant/c;->a()Ljava/lang/String;

    move-result-object v6

    iget-object v7, v0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->c:Ljava/lang/String;

    invoke-virtual {v5, v6, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    sget-object v6, Lcom/alipay/mobilesecuritysdk/constant/c;->c:Lcom/alipay/mobilesecuritysdk/constant/c;

    invoke-virtual {v6}, Lcom/alipay/mobilesecuritysdk/constant/c;->a()Ljava/lang/String;

    move-result-object v6

    iget-object v7, v0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->e:Ljava/lang/String;

    invoke-virtual {v5, v6, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    sget-object v6, Lcom/alipay/mobilesecuritysdk/constant/c;->d:Lcom/alipay/mobilesecuritysdk/constant/c;

    invoke-virtual {v6}, Lcom/alipay/mobilesecuritysdk/constant/c;->a()Ljava/lang/String;

    move-result-object v6

    iget-object v7, v0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->f:Ljava/lang/String;

    invoke-virtual {v5, v6, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    sget-object v6, Lcom/alipay/mobilesecuritysdk/constant/c;->e:Lcom/alipay/mobilesecuritysdk/constant/c;

    invoke-virtual {v6}, Lcom/alipay/mobilesecuritysdk/constant/c;->a()Ljava/lang/String;

    move-result-object v6

    iget-object v7, v0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->b:Ljava/lang/String;

    invoke-virtual {v5, v6, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string v6, "tid"

    invoke-direct {p0}, Lcom/alipay/mobilesecuritysdk/model/b;->c()Lorg/json/JSONArray;

    move-result-object v7

    invoke-virtual {v5, v6, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    sget-object v6, Lcom/alipay/mobilesecuritysdk/constant/c;->j:Lcom/alipay/mobilesecuritysdk/constant/c;

    invoke-virtual {v6}, Lcom/alipay/mobilesecuritysdk/constant/c;->a()Ljava/lang/String;

    move-result-object v6

    iget-object v7, v0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->h:Ljava/lang/String;

    invoke-virtual {v5, v6, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    sget-object v6, Lcom/alipay/mobilesecuritysdk/constant/c;->k:Lcom/alipay/mobilesecuritysdk/constant/c;

    invoke-virtual {v6}, Lcom/alipay/mobilesecuritysdk/constant/c;->a()Ljava/lang/String;

    move-result-object v6

    iget-object v7, v0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->i:Ljava/lang/String;

    invoke-virtual {v5, v6, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    sget-object v6, Lcom/alipay/mobilesecuritysdk/constant/c;->l:Lcom/alipay/mobilesecuritysdk/constant/c;

    invoke-virtual {v6}, Lcom/alipay/mobilesecuritysdk/constant/c;->a()Ljava/lang/String;

    move-result-object v6

    iget-object v7, v0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->g:Ljava/lang/String;

    invoke-virtual {v5, v6, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    iget-object v6, v0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->a:Ljava/util/List;

    if-eqz v6, :cond_3

    iget-object v0, v0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->a:Ljava/util/List;

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/model/b;->b(Ljava/util/List;)Lorg/json/JSONArray;

    move-result-object v0

    :goto_3
    if-eqz v0, :cond_2

    sget-object v6, Lcom/alipay/mobilesecuritysdk/constant/c;->f:Lcom/alipay/mobilesecuritysdk/constant/c;

    invoke-virtual {v6}, Lcom/alipay/mobilesecuritysdk/constant/c;->a()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    :cond_2
    const-string v0, "type"

    sget-object v6, Lcom/alipay/mobilesecuritysdk/constant/c;->h:Lcom/alipay/mobilesecuritysdk/constant/c;

    invoke-virtual {v6}, Lcom/alipay/mobilesecuritysdk/constant/c;->a()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v3, v0, v6}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string v0, "model"

    invoke-virtual {v3, v0, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_0
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_0

    goto/16 :goto_2

    :catch_0
    move-exception v0

    const-string v5, "location"

    invoke-virtual {v0}, Lorg/json/JSONException;->getLocalizedMessage()Ljava/lang/String;

    move-result-object v0

    invoke-static {v5, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto/16 :goto_2

    :cond_3
    move-object v0, v2

    goto :goto_3

    :cond_4
    move-object v1, v0

    goto/16 :goto_1

    :cond_5
    move-object v0, v2

    goto/16 :goto_0
.end method
