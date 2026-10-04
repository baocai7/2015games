.class public Lcn/uc/gamesdk/a/f;
.super Ljava/lang/Object;


# static fields
.field private static final a:Ljava/lang/String; = "UIRexConf"

.field private static final b:Ljava/lang/String; = "project"

.field private static final c:Ljava/lang/String; = "ucgamesdk/config/init_rexproj.xml"

.field private static final d:Ljava/lang/String; = "ucgamesdk/config/init_rexproj_landscape.xml"


# direct methods
.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static a()Ljava/lang/String;
    .locals 9

    const/4 v7, 0x0

    const/4 v4, 0x2

    :try_start_0
    invoke-static {}, Lorg/xmlpull/v1/XmlPullParserFactory;->newInstance()Lorg/xmlpull/v1/XmlPullParserFactory;

    move-result-object v0

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Lorg/xmlpull/v1/XmlPullParserFactory;->setValidating(Z)V

    invoke-virtual {v0}, Lorg/xmlpull/v1/XmlPullParserFactory;->newPullParser()Lorg/xmlpull/v1/XmlPullParser;

    move-result-object v0

    invoke-static {}, Lcn/uc/gamesdk/a/f;->d()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcn/uc/gamesdk/a/e;->c(Ljava/lang/String;)Ljava/io/InputStream;
    :try_end_0
    .catch Lorg/xmlpull/v1/XmlPullParserException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_1
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    move-result-object v1

    const/4 v2, 0x0

    :try_start_1
    invoke-interface {v0, v1, v2}, Lorg/xmlpull/v1/XmlPullParser;->setInput(Ljava/io/InputStream;Ljava/lang/String;)V

    :cond_0
    invoke-interface {v0}, Lorg/xmlpull/v1/XmlPullParser;->next()I

    move-result v2

    const/4 v3, 0x1

    if-eq v2, v3, :cond_1

    if-ne v2, v4, :cond_0

    const-string v2, "project"

    invoke-interface {v0}, Lorg/xmlpull/v1/XmlPullParser;->getName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_0

    const/4 v2, 0x0

    invoke-interface {v0, v2}, Lorg/xmlpull/v1/XmlPullParser;->getAttributeValue(I)Ljava/lang/String;
    :try_end_1
    .catch Lorg/xmlpull/v1/XmlPullParserException; {:try_start_1 .. :try_end_1} :catch_3
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_2
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    move-result-object v0

    invoke-static {v1}, Lcn/uc/gamesdk/d/e;->a(Ljava/io/Closeable;)V

    :goto_0
    return-object v0

    :cond_1
    invoke-static {v1}, Lcn/uc/gamesdk/d/e;->a(Ljava/io/Closeable;)V

    :goto_1
    move-object v0, v7

    goto :goto_0

    :catch_0
    move-exception v4

    move-object v8, v7

    :goto_2
    :try_start_2
    const-string v0, "UIRexConf"

    const-string v1, "getAssetsRexProj"

    const-string v2, "INNER"

    const-string v3, "\u8bfb\u53d6init_rexproj.xml\u6587\u4ef6\u9519\u8bef"

    const/4 v5, 0x2

    sget-object v6, Lcn/uc/gamesdk/a/a;->a:Ljava/lang/String;

    invoke-static/range {v0 .. v6}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;ILjava/lang/String;)V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_2

    invoke-static {v8}, Lcn/uc/gamesdk/d/e;->a(Ljava/io/Closeable;)V

    goto :goto_1

    :catch_1
    move-exception v4

    move-object v8, v7

    :goto_3
    :try_start_3
    const-string v0, "UIRexConf"

    const-string v1, "getAssetsRexProj"

    const-string v2, "INNER"

    const-string v3, "\u8bfb\u53d6init_rexproj.xml\u6587\u4ef6\u9519\u8bef"

    const/4 v5, 0x2

    sget-object v6, Lcn/uc/gamesdk/a/a;->a:Ljava/lang/String;

    invoke-static/range {v0 .. v6}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;ILjava/lang/String;)V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_2

    invoke-static {v8}, Lcn/uc/gamesdk/d/e;->a(Ljava/io/Closeable;)V

    goto :goto_1

    :catchall_0
    move-exception v0

    move-object v8, v7

    :goto_4
    invoke-static {v8}, Lcn/uc/gamesdk/d/e;->a(Ljava/io/Closeable;)V

    throw v0

    :catchall_1
    move-exception v0

    move-object v8, v1

    goto :goto_4

    :catchall_2
    move-exception v0

    goto :goto_4

    :catch_2
    move-exception v4

    move-object v8, v1

    goto :goto_3

    :catch_3
    move-exception v4

    move-object v8, v1

    goto :goto_2
.end method

.method public static a(Ljava/lang/String;)Ljava/lang/String;
    .locals 2

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "ucgamesdk"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    sget-object v1, Ljava/io/File;->separator:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "ui"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    sget-object v1, Ljava/io/File;->separator:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static b()V
    .locals 3

    const-string v0, "P"

    sget-object v1, Lcn/uc/gamesdk/UCOrientation;->LANDSCAPE:Lcn/uc/gamesdk/UCOrientation;

    invoke-virtual {v1}, Lcn/uc/gamesdk/UCOrientation;->ordinal()I

    move-result v1

    sget-object v2, Lcn/uc/gamesdk/a/d;->h:Lcn/uc/gamesdk/UCOrientation;

    invoke-virtual {v2}, Lcn/uc/gamesdk/UCOrientation;->ordinal()I

    move-result v2

    if-ne v1, v2, :cond_0

    const-string v0, "L"

    :cond_0
    invoke-static {v0}, Lcn/uc/gamesdk/c/a;->f(Ljava/lang/String;)V

    return-void
.end method

.method private static c()Ljava/lang/String;
    .locals 2

    const-string v0, "ucgamesdk/config/init_rexproj.xml"

    invoke-static {}, Lcn/uc/gamesdk/a/e;->c()Z

    move-result v1

    if-eqz v1, :cond_0

    const-string v0, "ucgamesdk/config/init_rexproj_landscape.xml"

    :cond_0
    return-object v0
.end method

.method private static d()Ljava/lang/String;
    .locals 7

    invoke-static {}, Lcn/uc/gamesdk/a/f;->c()Ljava/lang/String;

    move-result-object v1

    invoke-static {}, Lcn/uc/gamesdk/c/a;->m()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcn/uc/gamesdk/d/f;->k(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_0

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "."

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const/4 v2, 0x0

    :try_start_0
    invoke-static {v0}, Lcn/uc/gamesdk/a/e;->c(Ljava/lang/String;)Ljava/io/InputStream;
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    move-result-object v1

    invoke-static {v1}, Lcn/uc/gamesdk/d/e;->a(Ljava/io/Closeable;)V

    :goto_0
    const-string v1, "UIRexConf"

    const-string v2, "getInitRexProjXmlPath"

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "\u8bfb\u53d6\u8d44\u6e90\u914d\u7f6e\u6587\u4ef6\u8def\u5f84\uff0casset path="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v1, v2, v3}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return-object v0

    :catch_0
    move-exception v3

    :try_start_1
    const-string v3, "UIRexConf"

    const-string v4, "getInitRexProjXmlPath"

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "\u8bfb\u53d6\u8d44\u6e90\u914d\u7f6e\u6587\u4ef6\u5931\u8d25\uff0casset path="

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v3, v4, v0}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    invoke-static {v2}, Lcn/uc/gamesdk/d/e;->a(Ljava/io/Closeable;)V

    move-object v0, v1

    goto :goto_0

    :catchall_0
    move-exception v0

    invoke-static {v2}, Lcn/uc/gamesdk/d/e;->a(Ljava/io/Closeable;)V

    throw v0

    :cond_0
    move-object v0, v1

    goto :goto_0
.end method
