.class public Lcn/uc/gamesdk/b/b;
.super Ljava/lang/Object;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcn/uc/gamesdk/b/b$a;
    }
.end annotation


# static fields
.field private static final a:Ljava/lang/String; = "JarEntryParser"

.field private static final b:Ljava/lang/String; = "project"

.field private static final c:Ljava/lang/String; = "ve"

.field private static final d:Ljava/lang/String; = "minspace"

.field private static final e:Ljava/lang/String; = "jarApi"

.field private static final f:Ljava/lang/String; = "name"

.field private static final g:Ljava/lang/String; = "entry"

.field private static final h:Ljava/lang/String; = "entry"

.field private static final i:Ljava/lang/String; = "name"

.field private static final j:Ljava/lang/String; = "entryclass"

.field private static final k:Ljava/lang/String; = "entryjar"


# instance fields
.field private l:Ljava/util/HashMap;
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

.field private m:Ljava/util/LinkedHashMap;
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

.field private n:I


# direct methods
.method public constructor <init>()V
    .locals 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x2

    iput v0, p0, Lcn/uc/gamesdk/b/b;->n:I

    return-void
.end method

.method private b(Ljava/lang/String;)Ljava/lang/String;
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    :try_start_0
    new-instance v0, Ljava/io/FileInputStream;

    new-instance v1, Ljava/io/File;

    invoke-direct {v1, p1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-direct {v0, v1}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V

    invoke-static {v0}, Lcn/uc/gamesdk/d/e;->b(Ljava/io/InputStream;)[B

    move-result-object v0

    invoke-static {v0}, Lcn/uc/gamesdk/d/b/e;->a([B)Ljava/lang/String;
    :try_end_0
    .catch Ljava/io/FileNotFoundException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_1

    move-result-object v0

    return-object v0

    :catch_0
    move-exception v0

    new-instance v0, Ljava/io/IOException;

    const-string v1, "\u627e\u4e0d\u5230XML\u6587\u4ef6\u6216\u6587\u4ef6\u4e0d\u53ef\u8bfb"

    invoke-direct {v0, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v0

    :catch_1
    move-exception v0

    new-instance v0, Ljava/io/IOException;

    const-string v1, "entry.xml\u8bfb\u53d6\u9519\u8bef"

    invoke-direct {v0, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v0
.end method


# virtual methods
.method public a()I
    .locals 1

    iget v0, p0, Lcn/uc/gamesdk/b/b;->n:I

    return v0
.end method

.method public a(Ljava/lang/String;)V
    .locals 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;,
            Lorg/xmlpull/v1/XmlPullParserException;
        }
    .end annotation

    invoke-static {p1}, Lcn/uc/gamesdk/d/f;->c(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_5

    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    iput-object v0, p0, Lcn/uc/gamesdk/b/b;->l:Ljava/util/HashMap;

    new-instance v0, Ljava/util/LinkedHashMap;

    invoke-direct {v0}, Ljava/util/LinkedHashMap;-><init>()V

    iput-object v0, p0, Lcn/uc/gamesdk/b/b;->m:Ljava/util/LinkedHashMap;

    invoke-direct {p0, p1}, Lcn/uc/gamesdk/b/b;->b(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_5

    :try_start_0
    invoke-static {}, Lorg/xmlpull/v1/XmlPullParserFactory;->newInstance()Lorg/xmlpull/v1/XmlPullParserFactory;

    move-result-object v1

    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Lorg/xmlpull/v1/XmlPullParserFactory;->setValidating(Z)V

    invoke-virtual {v1}, Lorg/xmlpull/v1/XmlPullParserFactory;->newPullParser()Lorg/xmlpull/v1/XmlPullParser;

    move-result-object v1

    new-instance v2, Ljava/io/StringReader;

    invoke-direct {v2, v0}, Ljava/io/StringReader;-><init>(Ljava/lang/String;)V

    invoke-interface {v1, v2}, Lorg/xmlpull/v1/XmlPullParser;->setInput(Ljava/io/Reader;)V

    const/4 v0, -0x1

    const-string v2, ""

    const-string v2, ""

    const-string v2, ""

    const-string v2, ""

    :goto_0
    const/4 v2, 0x1

    if-eq v0, v2, :cond_5

    const/4 v2, 0x2

    if-ne v0, v2, :cond_1

    invoke-interface {v1}, Lorg/xmlpull/v1/XmlPullParser;->getName()Ljava/lang/String;

    move-result-object v0

    const-string v2, "project"

    invoke-virtual {v2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_2

    const/4 v0, 0x0

    const-string v2, "ve"

    invoke-interface {v1, v0, v2}, Lorg/xmlpull/v1/XmlPullParser;->getAttributeValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const/4 v2, 0x0

    const-string v3, "minspace"

    invoke-interface {v1, v2, v3}, Lorg/xmlpull/v1/XmlPullParser;->getAttributeValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    if-eqz v2, :cond_0

    invoke-static {v2}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v2

    iput v2, p0, Lcn/uc/gamesdk/b/b;->n:I

    :cond_0
    sput-object v0, Lcn/uc/gamesdk/a/a;->b:Ljava/lang/String;

    :cond_1
    :goto_1
    invoke-interface {v1}, Lorg/xmlpull/v1/XmlPullParser;->next()I

    move-result v0

    goto :goto_0

    :cond_2
    const-string v2, "jarApi"

    invoke-virtual {v2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_4

    const/4 v0, 0x0

    const-string v2, "name"

    invoke-interface {v1, v0, v2}, Lorg/xmlpull/v1/XmlPullParser;->getAttributeValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const/4 v2, 0x0

    const-string v3, "entry"

    invoke-interface {v1, v2, v3}, Lorg/xmlpull/v1/XmlPullParser;->getAttributeValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-static {v0}, Lcn/uc/gamesdk/iface/Commands;->getCommand(Ljava/lang/String;)Lcn/uc/gamesdk/iface/Commands;

    move-result-object v3

    if-eqz v3, :cond_3

    iget-object v3, p0, Lcn/uc/gamesdk/b/b;->l:Ljava/util/HashMap;

    invoke-static {v0}, Lcn/uc/gamesdk/iface/Commands;->getCommand(Ljava/lang/String;)Lcn/uc/gamesdk/iface/Commands;

    move-result-object v0

    invoke-virtual {v3, v0, v2}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Lorg/xmlpull/v1/XmlPullParserException; {:try_start_0 .. :try_end_0} :catch_1

    goto :goto_1

    :catch_0
    move-exception v0

    new-instance v0, Ljava/io/IOException;

    const-string v1, "\u8bfb\u53d6Jar\u914d\u7f6e\u6587\u4ef6\u51fa\u9519"

    invoke-direct {v0, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v0

    :cond_3
    :try_start_1
    new-instance v0, Lorg/xmlpull/v1/XmlPullParserException;

    const-string v1, "\u627e\u4e0d\u5230\u914d\u7f6e\u6587\u4ef6\u5b9a\u4e49\u7684\u63a5\u53e3,\u914d\u7f6e\u6587\u4ef6\u9519\u8bef"

    invoke-direct {v0, v1}, Lorg/xmlpull/v1/XmlPullParserException;-><init>(Ljava/lang/String;)V

    throw v0
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0
    .catch Lorg/xmlpull/v1/XmlPullParserException; {:try_start_1 .. :try_end_1} :catch_1

    :catch_1
    move-exception v0

    new-instance v0, Lorg/xmlpull/v1/XmlPullParserException;

    const-string v1, "\u89e3\u6790Jar\u914d\u7f6e\u6587\u4ef6\u51fa\u9519"

    invoke-direct {v0, v1}, Lorg/xmlpull/v1/XmlPullParserException;-><init>(Ljava/lang/String;)V

    throw v0

    :cond_4
    :try_start_2
    const-string v2, "entry"

    invoke-virtual {v2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    new-instance v0, Lcn/uc/gamesdk/b/b$a;

    invoke-direct {v0, p0}, Lcn/uc/gamesdk/b/b$a;-><init>(Lcn/uc/gamesdk/b/b;)V

    const/4 v2, 0x0

    const-string v3, "name"

    invoke-interface {v1, v2, v3}, Lorg/xmlpull/v1/XmlPullParser;->getAttributeValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    const/4 v3, 0x0

    const-string v4, "entryclass"

    invoke-interface {v1, v3, v4}, Lorg/xmlpull/v1/XmlPullParser;->getAttributeValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    const/4 v4, 0x0

    const-string v5, "entryjar"

    invoke-interface {v1, v4, v5}, Lorg/xmlpull/v1/XmlPullParser;->getAttributeValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    iput-object v3, v0, Lcn/uc/gamesdk/b/b$a;->a:Ljava/lang/String;

    iput-object v4, v0, Lcn/uc/gamesdk/b/b$a;->b:Ljava/lang/String;

    iget-object v3, p0, Lcn/uc/gamesdk/b/b;->m:Ljava/util/LinkedHashMap;

    invoke-virtual {v3, v2, v0}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_2
    .catch Ljava/io/IOException; {:try_start_2 .. :try_end_2} :catch_0
    .catch Lorg/xmlpull/v1/XmlPullParserException; {:try_start_2 .. :try_end_2} :catch_1

    goto :goto_1

    :cond_5
    return-void
.end method

.method public b()Ljava/util/HashMap;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/HashMap",
            "<",
            "Lcn/uc/gamesdk/iface/Commands;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    iget-object v0, p0, Lcn/uc/gamesdk/b/b;->l:Ljava/util/HashMap;

    return-object v0
.end method

.method public c()Ljava/util/LinkedHashMap;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/LinkedHashMap",
            "<",
            "Ljava/lang/String;",
            "Lcn/uc/gamesdk/b/b$a;",
            ">;"
        }
    .end annotation

    iget-object v0, p0, Lcn/uc/gamesdk/b/b;->m:Ljava/util/LinkedHashMap;

    return-object v0
.end method

.method public d()Ljava/lang/String;
    .locals 1

    sget-object v0, Lcn/uc/gamesdk/a/a;->b:Ljava/lang/String;

    return-object v0
.end method
