.class public Lcn/uc/a/a/a/a/b/b;
.super Ljava/lang/Object;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcn/uc/a/a/a/a/b/b$a;,
        Lcn/uc/a/a/a/a/b/b$b;
    }
.end annotation


# static fields
.field public static final a:I = -0x1

.field public static final b:I = -0x2

.field public static final c:I = -0x3

.field public static final d:I = -0x4

.field protected static final e:Ljava/lang/String; = "Accept-Encoding"

.field protected static final f:Ljava/lang/String; = "content-type"

.field protected static final g:Ljava/lang/String; = "gzip"

.field protected static final h:Ljava/lang/String; = "application/x-www-form-urlencoded"

.field private static final m:I = 0x4e20

.field private static final n:I = 0x9c40

.field private static final o:Ljava/lang/String; = "UTF-8"

.field private static final p:Ljava/lang/String; = "location"

.field private static final q:Ljava/lang/String; = "HttpConnection"

.field private static w:Lorg/apache/http/conn/ssl/X509HostnameVerifier;


# instance fields
.field protected i:Ljava/lang/String;

.field protected j:Lorg/apache/http/HttpHost;

.field protected k:Landroid/content/Context;

.field protected l:I

.field private r:Ljava/lang/String;

.field private s:I

.field private t:Ljava/net/HttpURLConnection;

.field private u:Lorg/apache/http/client/HttpClient;

.field private v:Z


# direct methods
.method static constructor <clinit>()V
    .locals 1

    new-instance v0, Lcn/uc/a/a/a/a/b/b$1;

    invoke-direct {v0}, Lcn/uc/a/a/a/a/b/b$1;-><init>()V

    sput-object v0, Lcn/uc/a/a/a/a/b/b;->w:Lorg/apache/http/conn/ssl/X509HostnameVerifier;

    return-void
.end method

.method public constructor <init>()V
    .locals 2

    const/4 v1, 0x0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const-string v0, ""

    iput-object v0, p0, Lcn/uc/a/a/a/a/b/b;->i:Ljava/lang/String;

    iput-object v1, p0, Lcn/uc/a/a/a/a/b/b;->j:Lorg/apache/http/HttpHost;

    iput-object v1, p0, Lcn/uc/a/a/a/a/b/b;->k:Landroid/content/Context;

    iput-object v1, p0, Lcn/uc/a/a/a/a/b/b;->r:Ljava/lang/String;

    const/4 v0, -0x1

    iput v0, p0, Lcn/uc/a/a/a/a/b/b;->s:I

    iput-object v1, p0, Lcn/uc/a/a/a/a/b/b;->t:Ljava/net/HttpURLConnection;

    iput-object v1, p0, Lcn/uc/a/a/a/a/b/b;->u:Lorg/apache/http/client/HttpClient;

    const/4 v0, 0x0

    iput-boolean v0, p0, Lcn/uc/a/a/a/a/b/b;->v:Z

    invoke-static {}, Lcn/uc/a/a/a/a;->a()Landroid/content/Context;

    move-result-object v0

    iput-object v0, p0, Lcn/uc/a/a/a/a/b/b;->k:Landroid/content/Context;

    iget-object v0, p0, Lcn/uc/a/a/a/a/b/b;->k:Landroid/content/Context;

    invoke-static {v0}, Lcn/uc/a/a/a/b/a;->l(Landroid/content/Context;)Lorg/apache/http/HttpHost;

    move-result-object v0

    iput-object v0, p0, Lcn/uc/a/a/a/a/b/b;->j:Lorg/apache/http/HttpHost;

    return-void
.end method

.method public constructor <init>(Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0}, Lcn/uc/a/a/a/a/b/b;-><init>()V

    iput-object p1, p0, Lcn/uc/a/a/a/a/b/b;->i:Ljava/lang/String;

    return-void
.end method

.method public static a(Landroid/content/Context;)I
    .locals 1

    invoke-static {p0}, Lcn/uc/a/a/a/b/a;->f(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_0

    const v0, 0x9c40

    :goto_0
    return v0

    :cond_0
    const/16 v0, 0x4e20

    goto :goto_0
.end method

.method protected static a(Landroid/content/Context;Ljava/lang/String;)Lorg/apache/http/impl/client/DefaultHttpClient;
    .locals 5

    new-instance v1, Lorg/apache/http/conn/scheme/SchemeRegistry;

    invoke-direct {v1}, Lorg/apache/http/conn/scheme/SchemeRegistry;-><init>()V

    new-instance v0, Lorg/apache/http/conn/scheme/Scheme;

    const-string v2, "http"

    invoke-static {}, Lorg/apache/http/conn/scheme/PlainSocketFactory;->getSocketFactory()Lorg/apache/http/conn/scheme/PlainSocketFactory;

    move-result-object v3

    const/16 v4, 0x50

    invoke-direct {v0, v2, v3, v4}, Lorg/apache/http/conn/scheme/Scheme;-><init>(Ljava/lang/String;Lorg/apache/http/conn/scheme/SocketFactory;I)V

    invoke-virtual {v1, v0}, Lorg/apache/http/conn/scheme/SchemeRegistry;->register(Lorg/apache/http/conn/scheme/Scheme;)Lorg/apache/http/conn/scheme/Scheme;

    :try_start_0
    invoke-static {}, Ljava/security/KeyStore;->getDefaultType()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ljava/security/KeyStore;->getInstance(Ljava/lang/String;)Ljava/security/KeyStore;

    move-result-object v0

    const/4 v2, 0x0

    const/4 v3, 0x0

    invoke-virtual {v0, v2, v3}, Ljava/security/KeyStore;->load(Ljava/io/InputStream;[C)V

    new-instance v2, Lcn/uc/a/a/a/a/b/b$b;

    invoke-direct {v2, v0}, Lcn/uc/a/a/a/a/b/b$b;-><init>(Ljava/security/KeyStore;)V

    sget-object v0, Lcn/uc/a/a/a/a/b/b;->w:Lorg/apache/http/conn/ssl/X509HostnameVerifier;

    invoke-virtual {v2, v0}, Lorg/apache/http/conn/ssl/SSLSocketFactory;->setHostnameVerifier(Lorg/apache/http/conn/ssl/X509HostnameVerifier;)V

    new-instance v0, Lorg/apache/http/conn/scheme/Scheme;

    const-string v3, "https"

    const/16 v4, 0x1bb

    invoke-direct {v0, v3, v2, v4}, Lorg/apache/http/conn/scheme/Scheme;-><init>(Ljava/lang/String;Lorg/apache/http/conn/scheme/SocketFactory;I)V

    invoke-virtual {v1, v0}, Lorg/apache/http/conn/scheme/SchemeRegistry;->register(Lorg/apache/http/conn/scheme/Scheme;)Lorg/apache/http/conn/scheme/Scheme;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :goto_0
    new-instance v0, Lorg/apache/http/params/BasicHttpParams;

    invoke-direct {v0}, Lorg/apache/http/params/BasicHttpParams;-><init>()V

    new-instance v2, Lorg/apache/http/impl/conn/tsccm/ThreadSafeClientConnManager;

    invoke-direct {v2, v0, v1}, Lorg/apache/http/impl/conn/tsccm/ThreadSafeClientConnManager;-><init>(Lorg/apache/http/params/HttpParams;Lorg/apache/http/conn/scheme/SchemeRegistry;)V

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v1

    if-lez v1, :cond_0

    const-string v1, "http.useragent"

    invoke-interface {v0, v1, p1}, Lorg/apache/http/params/HttpParams;->setParameter(Ljava/lang/String;Ljava/lang/Object;)Lorg/apache/http/params/HttpParams;

    :cond_0
    invoke-static {p0}, Lcn/uc/a/a/a/a/b/b;->a(Landroid/content/Context;)I

    move-result v1

    invoke-static {v0, v1}, Lorg/apache/http/params/HttpConnectionParams;->setConnectionTimeout(Lorg/apache/http/params/HttpParams;I)V

    invoke-static {p0}, Lcn/uc/a/a/a/a/b/b;->a(Landroid/content/Context;)I

    move-result v1

    invoke-static {v0, v1}, Lorg/apache/http/params/HttpConnectionParams;->setSoTimeout(Lorg/apache/http/params/HttpParams;I)V

    new-instance v1, Lorg/apache/http/impl/client/DefaultHttpClient;

    invoke-direct {v1, v2, v0}, Lorg/apache/http/impl/client/DefaultHttpClient;-><init>(Lorg/apache/http/conn/ClientConnectionManager;Lorg/apache/http/params/HttpParams;)V

    invoke-static {v1, p0}, Lcn/uc/a/a/a/a/b/b;->a(Lorg/apache/http/impl/client/DefaultHttpClient;Landroid/content/Context;)V

    new-instance v0, Lcn/uc/a/a/a/a/b/b$2;

    invoke-direct {v0}, Lcn/uc/a/a/a/a/b/b$2;-><init>()V

    invoke-virtual {v1, v0}, Lorg/apache/http/impl/client/DefaultHttpClient;->addRequestInterceptor(Lorg/apache/http/HttpRequestInterceptor;)V

    new-instance v0, Lcn/uc/a/a/a/a/b/b$3;

    invoke-direct {v0}, Lcn/uc/a/a/a/a/b/b$3;-><init>()V

    invoke-virtual {v1, v0}, Lorg/apache/http/impl/client/DefaultHttpClient;->addResponseInterceptor(Lorg/apache/http/HttpResponseInterceptor;)V

    return-object v1

    :catch_0
    move-exception v0

    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_0
.end method

.method private static a(Lorg/apache/http/impl/client/DefaultHttpClient;Landroid/content/Context;)V
    .locals 3

    invoke-static {p1}, Lcn/uc/a/a/a/b/a;->f(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-static {p1}, Lcn/uc/a/a/a/b/a;->c(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_0

    new-instance v1, Lorg/apache/http/HttpHost;

    invoke-static {p1}, Lcn/uc/a/a/a/b/a;->e(Landroid/content/Context;)I

    move-result v2

    invoke-direct {v1, v0, v2}, Lorg/apache/http/HttpHost;-><init>(Ljava/lang/String;I)V

    invoke-virtual {p0}, Lorg/apache/http/impl/client/DefaultHttpClient;->getParams()Lorg/apache/http/params/HttpParams;

    move-result-object v0

    const-string v2, "http.route.default-proxy"

    invoke-interface {v0, v2, v1}, Lorg/apache/http/params/HttpParams;->setParameter(Ljava/lang/String;Ljava/lang/Object;)Lorg/apache/http/params/HttpParams;

    :cond_0
    return-void
.end method

.method private static a(Ljava/io/InputStream;)[B
    .locals 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    const/16 v5, 0x400

    const/4 v4, 0x0

    new-instance v0, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v0}, Ljava/io/ByteArrayOutputStream;-><init>()V

    new-array v1, v5, [B

    :goto_0
    invoke-virtual {p0, v1, v4, v5}, Ljava/io/InputStream;->read([BII)I

    move-result v2

    const/4 v3, -0x1

    if-eq v2, v3, :cond_0

    invoke-virtual {v0, v1, v4, v2}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    goto :goto_0

    :cond_0
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v0

    return-object v0
.end method

.method private b(Ljava/lang/String;[B)[B
    .locals 10
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/apache/http/client/ClientProtocolException;,
            Ljava/io/IOException;
        }
    .end annotation

    const/4 v8, 0x0

    const/4 v7, -0x2

    const/4 v6, -0x4

    const/4 v1, 0x0

    iget-object v0, p0, Lcn/uc/a/a/a/a/b/b;->k:Landroid/content/Context;

    invoke-static {v0}, Lcn/uc/a/a/a/b/a;->j(Landroid/content/Context;)Z

    move-result v0

    if-nez v0, :cond_0

    const/4 v0, -0x1

    iput v0, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    :goto_0
    return-object v1

    :cond_0
    :try_start_0
    iget-object v0, p0, Lcn/uc/a/a/a/a/b/b;->k:Landroid/content/Context;

    iget-object v2, p0, Lcn/uc/a/a/a/a/b/b;->i:Ljava/lang/String;

    invoke-static {v0, v2}, Lcn/uc/a/a/a/a/b/b;->a(Landroid/content/Context;Ljava/lang/String;)Lorg/apache/http/impl/client/DefaultHttpClient;

    move-result-object v0

    iput-object v0, p0, Lcn/uc/a/a/a/a/b/b;->u:Lorg/apache/http/client/HttpClient;

    new-instance v0, Lorg/apache/http/client/methods/HttpPost;

    invoke-direct {v0, p1}, Lorg/apache/http/client/methods/HttpPost;-><init>(Ljava/lang/String;)V

    const-string v2, "Accept-Encoding"

    const-string v3, "application/x-www-form-urlencoded"

    invoke-virtual {v0, v2, v3}, Lorg/apache/http/client/methods/HttpPost;->setHeader(Ljava/lang/String;Ljava/lang/String;)V

    new-instance v2, Lorg/apache/http/entity/ByteArrayEntity;

    invoke-direct {v2, p2}, Lorg/apache/http/entity/ByteArrayEntity;-><init>([B)V

    invoke-virtual {v0, v2}, Lorg/apache/http/client/methods/HttpPost;->setEntity(Lorg/apache/http/HttpEntity;)V

    iget-boolean v2, p0, Lcn/uc/a/a/a/a/b/b;->v:Z

    if-nez v2, :cond_b

    iget-object v2, p0, Lcn/uc/a/a/a/a/b/b;->u:Lorg/apache/http/client/HttpClient;

    invoke-interface {v2, v0}, Lorg/apache/http/client/HttpClient;->execute(Lorg/apache/http/client/methods/HttpUriRequest;)Lorg/apache/http/HttpResponse;
    :try_end_0
    .catch Lorg/apache/http/client/ClientProtocolException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_1
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    move-result-object v2

    :try_start_1
    invoke-interface {v2}, Lorg/apache/http/HttpResponse;->getEntity()Lorg/apache/http/HttpEntity;

    move-result-object v0

    invoke-static {v0}, Lorg/apache/http/util/EntityUtils;->toByteArray(Lorg/apache/http/HttpEntity;)[B
    :try_end_1
    .catch Lorg/apache/http/client/ClientProtocolException; {:try_start_1 .. :try_end_1} :catch_4
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_2
    .catchall {:try_start_1 .. :try_end_1} :catchall_2

    move-result-object v3

    :try_start_2
    iget-object v0, p0, Lcn/uc/a/a/a/a/b/b;->u:Lorg/apache/http/client/HttpClient;

    invoke-interface {v0}, Lorg/apache/http/client/HttpClient;->getConnectionManager()Lorg/apache/http/conn/ClientConnectionManager;

    move-result-object v0

    invoke-interface {v0}, Lorg/apache/http/conn/ClientConnectionManager;->shutdown()V
    :try_end_2
    .catch Lorg/apache/http/client/ClientProtocolException; {:try_start_2 .. :try_end_2} :catch_5
    .catch Ljava/io/IOException; {:try_start_2 .. :try_end_2} :catch_3
    .catchall {:try_start_2 .. :try_end_2} :catchall_2

    move-object v0, v3

    :goto_1
    if-eqz v2, :cond_2

    invoke-interface {v2}, Lorg/apache/http/HttpResponse;->getStatusLine()Lorg/apache/http/StatusLine;

    move-result-object v2

    invoke-interface {v2}, Lorg/apache/http/StatusLine;->getStatusCode()I

    move-result v2

    iput v2, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iget v2, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iput v2, p0, Lcn/uc/a/a/a/a/b/b;->s:I

    :goto_2
    iget-boolean v2, p0, Lcn/uc/a/a/a/a/b/b;->v:Z

    if-eqz v2, :cond_1

    iput v6, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    move-object v0, v1

    :cond_1
    iput-boolean v8, p0, Lcn/uc/a/a/a/a/b/b;->v:Z

    iput-object v1, p0, Lcn/uc/a/a/a/a/b/b;->t:Ljava/net/HttpURLConnection;

    iput-object v1, p0, Lcn/uc/a/a/a/a/b/b;->u:Lorg/apache/http/client/HttpClient;

    :goto_3
    move-object v1, v0

    goto :goto_0

    :cond_2
    iput v7, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    goto :goto_2

    :catch_0
    move-exception v0

    move-object v2, v0

    move-object v3, v1

    move-object v0, v1

    :goto_4
    :try_start_3
    iget-boolean v4, p0, Lcn/uc/a/a/a/a/b/b;->v:Z

    if-eqz v4, :cond_4

    const-string v2, "HttpConnection"

    const-string v4, "getBodyStrByPostHttpClient"

    const-string v5, "\u4e3b\u52a8\u65ad\u5f00HTTP\u8fde\u63a5"

    invoke-static {v2, v4, v5}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const/4 v2, -0x4

    iput v2, p0, Lcn/uc/a/a/a/a/b/b;->l:I
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    if-eqz v3, :cond_6

    invoke-interface {v3}, Lorg/apache/http/HttpResponse;->getStatusLine()Lorg/apache/http/StatusLine;

    move-result-object v2

    invoke-interface {v2}, Lorg/apache/http/StatusLine;->getStatusCode()I

    move-result v2

    iput v2, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iget v2, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iput v2, p0, Lcn/uc/a/a/a/a/b/b;->s:I

    :goto_5
    iget-boolean v2, p0, Lcn/uc/a/a/a/a/b/b;->v:Z

    if-eqz v2, :cond_3

    iput v6, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    move-object v0, v1

    :cond_3
    iput-boolean v8, p0, Lcn/uc/a/a/a/a/b/b;->v:Z

    iput-object v1, p0, Lcn/uc/a/a/a/a/b/b;->t:Ljava/net/HttpURLConnection;

    iput-object v1, p0, Lcn/uc/a/a/a/a/b/b;->u:Lorg/apache/http/client/HttpClient;

    goto :goto_3

    :cond_4
    :try_start_4
    throw v2
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    :catchall_0
    move-exception v0

    :goto_6
    if-eqz v3, :cond_a

    invoke-interface {v3}, Lorg/apache/http/HttpResponse;->getStatusLine()Lorg/apache/http/StatusLine;

    move-result-object v2

    invoke-interface {v2}, Lorg/apache/http/StatusLine;->getStatusCode()I

    move-result v2

    iput v2, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iget v2, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iput v2, p0, Lcn/uc/a/a/a/a/b/b;->s:I

    :goto_7
    iget-boolean v2, p0, Lcn/uc/a/a/a/a/b/b;->v:Z

    if-eqz v2, :cond_5

    iput v6, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    :cond_5
    iput-boolean v8, p0, Lcn/uc/a/a/a/a/b/b;->v:Z

    iput-object v1, p0, Lcn/uc/a/a/a/a/b/b;->t:Ljava/net/HttpURLConnection;

    iput-object v1, p0, Lcn/uc/a/a/a/a/b/b;->u:Lorg/apache/http/client/HttpClient;

    throw v0

    :cond_6
    iput v7, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    goto :goto_5

    :catch_1
    move-exception v0

    move-object v2, v0

    move-object v3, v1

    move-object v0, v1

    :goto_8
    :try_start_5
    iget-boolean v4, p0, Lcn/uc/a/a/a/a/b/b;->v:Z

    if-eqz v4, :cond_8

    const-string v2, "HttpConnection"

    const-string v4, "getBodyStrByPostHttpClient"

    const-string v5, "\u4e3b\u52a8\u65ad\u5f00HTTP\u8fde\u63a5"

    invoke-static {v2, v4, v5}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const/4 v2, -0x4

    iput v2, p0, Lcn/uc/a/a/a/a/b/b;->l:I
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_0

    if-eqz v3, :cond_9

    invoke-interface {v3}, Lorg/apache/http/HttpResponse;->getStatusLine()Lorg/apache/http/StatusLine;

    move-result-object v2

    invoke-interface {v2}, Lorg/apache/http/StatusLine;->getStatusCode()I

    move-result v2

    iput v2, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iget v2, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iput v2, p0, Lcn/uc/a/a/a/a/b/b;->s:I

    :goto_9
    iget-boolean v2, p0, Lcn/uc/a/a/a/a/b/b;->v:Z

    if-eqz v2, :cond_7

    iput v6, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    move-object v0, v1

    :cond_7
    iput-boolean v8, p0, Lcn/uc/a/a/a/a/b/b;->v:Z

    iput-object v1, p0, Lcn/uc/a/a/a/a/b/b;->t:Ljava/net/HttpURLConnection;

    iput-object v1, p0, Lcn/uc/a/a/a/a/b/b;->u:Lorg/apache/http/client/HttpClient;

    goto/16 :goto_3

    :cond_8
    :try_start_6
    throw v2
    :try_end_6
    .catchall {:try_start_6 .. :try_end_6} :catchall_0

    :cond_9
    iput v7, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    goto :goto_9

    :cond_a
    iput v7, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    goto :goto_7

    :catchall_1
    move-exception v0

    move-object v3, v1

    goto :goto_6

    :catchall_2
    move-exception v0

    move-object v3, v2

    goto :goto_6

    :catch_2
    move-exception v0

    move-object v3, v2

    move-object v2, v0

    move-object v0, v1

    goto :goto_8

    :catch_3
    move-exception v0

    move-object v9, v0

    move-object v0, v3

    move-object v3, v2

    move-object v2, v9

    goto :goto_8

    :catch_4
    move-exception v0

    move-object v3, v2

    move-object v2, v0

    move-object v0, v1

    goto/16 :goto_4

    :catch_5
    move-exception v0

    move-object v9, v0

    move-object v0, v3

    move-object v3, v2

    move-object v2, v9

    goto/16 :goto_4

    :cond_b
    move-object v2, v1

    move-object v0, v1

    goto/16 :goto_1
.end method

.method private c(Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    invoke-static {}, Landroid/webkit/CookieManager;->getInstance()Landroid/webkit/CookieManager;

    move-result-object v0

    invoke-virtual {v0, p1}, Landroid/webkit/CookieManager;->getCookie(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method private c(Ljava/lang/String;[B)[B
    .locals 7
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/apache/http/client/ClientProtocolException;,
            Ljava/io/IOException;
        }
    .end annotation

    const/4 v6, 0x0

    const/4 v5, -0x4

    const/4 v1, 0x0

    iget-object v2, p0, Lcn/uc/a/a/a/a/b/b;->k:Landroid/content/Context;

    invoke-static {v2}, Lcn/uc/a/a/a/b/a;->j(Landroid/content/Context;)Z

    move-result v0

    if-nez v0, :cond_0

    const/4 v0, -0x1

    iput v0, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    :goto_0
    return-object v1

    :cond_0
    :try_start_0
    new-instance v0, Ljava/net/URL;

    invoke-direct {v0, p1}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;

    move-result-object v0

    check-cast v0, Ljava/net/HttpURLConnection;

    iput-object v0, p0, Lcn/uc/a/a/a/a/b/b;->t:Ljava/net/HttpURLConnection;

    iget-object v0, p0, Lcn/uc/a/a/a/a/b/b;->t:Ljava/net/HttpURLConnection;

    invoke-static {v2}, Lcn/uc/a/a/a/a/b/b;->a(Landroid/content/Context;)I

    move-result v3

    invoke-virtual {v0, v3}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V

    iget-object v0, p0, Lcn/uc/a/a/a/a/b/b;->t:Ljava/net/HttpURLConnection;

    invoke-static {v2}, Lcn/uc/a/a/a/a/b/b;->a(Landroid/content/Context;)I

    move-result v2

    invoke-virtual {v0, v2}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    iget-object v0, p0, Lcn/uc/a/a/a/a/b/b;->t:Ljava/net/HttpURLConnection;

    const/4 v2, 0x1

    invoke-virtual {v0, v2}, Ljava/net/HttpURLConnection;->setDoOutput(Z)V

    iget-object v0, p0, Lcn/uc/a/a/a/a/b/b;->t:Ljava/net/HttpURLConnection;

    const/4 v2, 0x1

    invoke-virtual {v0, v2}, Ljava/net/HttpURLConnection;->setDoInput(Z)V

    iget-object v0, p0, Lcn/uc/a/a/a/a/b/b;->t:Ljava/net/HttpURLConnection;

    const-string v2, "POST"

    invoke-virtual {v0, v2}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V

    iget-object v0, p0, Lcn/uc/a/a/a/a/b/b;->t:Ljava/net/HttpURLConnection;

    const/4 v2, 0x0

    invoke-virtual {v0, v2}, Ljava/net/HttpURLConnection;->setUseCaches(Z)V

    iget-object v0, p0, Lcn/uc/a/a/a/a/b/b;->t:Ljava/net/HttpURLConnection;

    const/4 v2, 0x1

    invoke-virtual {v0, v2}, Ljava/net/HttpURLConnection;->setInstanceFollowRedirects(Z)V

    iget-object v0, p0, Lcn/uc/a/a/a/a/b/b;->t:Ljava/net/HttpURLConnection;

    const-string v2, "Content-Type"

    const-string v3, "application/x-www-form-urlencoded"

    invoke-virtual {v0, v2, v3}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    const-string v0, "http.keepAlive"

    const-string v2, "false"

    invoke-static {v0, v2}, Ljava/lang/System;->setProperty(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    iget-object v0, p0, Lcn/uc/a/a/a/a/b/b;->k:Landroid/content/Context;

    invoke-static {v0}, Lcn/uc/a/a/a/b/a;->f(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_4

    iget-object v0, p0, Lcn/uc/a/a/a/a/b/b;->k:Landroid/content/Context;

    invoke-static {v0}, Lcn/uc/a/a/a/b/a;->c(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_2

    const-string v2, "http.proxyHost"

    invoke-static {v2, v0}, Ljava/lang/System;->setProperty(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    const-string v0, "http.proxyPort"

    iget-object v2, p0, Lcn/uc/a/a/a/a/b/b;->k:Landroid/content/Context;

    invoke-static {v2}, Lcn/uc/a/a/a/b/a;->e(Landroid/content/Context;)I

    move-result v2

    invoke-static {v2}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v2}, Ljava/lang/System;->setProperty(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    :goto_1
    iget-object v0, p0, Lcn/uc/a/a/a/a/b/b;->t:Ljava/net/HttpURLConnection;

    invoke-virtual {v0}, Ljava/net/HttpURLConnection;->connect()V

    iget-boolean v0, p0, Lcn/uc/a/a/a/a/b/b;->v:Z

    if-nez v0, :cond_9

    new-instance v0, Ljava/io/DataOutputStream;

    iget-object v2, p0, Lcn/uc/a/a/a/a/b/b;->t:Ljava/net/HttpURLConnection;

    invoke-virtual {v2}, Ljava/net/HttpURLConnection;->getOutputStream()Ljava/io/OutputStream;

    move-result-object v2

    invoke-direct {v0, v2}, Ljava/io/DataOutputStream;-><init>(Ljava/io/OutputStream;)V

    invoke-virtual {v0, p2}, Ljava/io/DataOutputStream;->write([B)V

    invoke-virtual {v0}, Ljava/io/DataOutputStream;->flush()V

    iget-object v2, p0, Lcn/uc/a/a/a/a/b/b;->t:Ljava/net/HttpURLConnection;

    invoke-virtual {v2}, Ljava/net/HttpURLConnection;->getResponseCode()I

    move-result v2

    iput v2, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iget v2, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iput v2, p0, Lcn/uc/a/a/a/a/b/b;->s:I

    invoke-virtual {v0}, Ljava/io/DataOutputStream;->close()V

    iget-object v0, p0, Lcn/uc/a/a/a/a/b/b;->t:Ljava/net/HttpURLConnection;

    invoke-virtual {v0}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;

    move-result-object v0

    invoke-static {v0}, Lcn/uc/a/a/a/a/b/b;->a(Ljava/io/InputStream;)[B
    :try_end_0
    .catch Lorg/apache/http/client/ClientProtocolException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_1
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    move-result-object v0

    :try_start_1
    iget-object v2, p0, Lcn/uc/a/a/a/a/b/b;->t:Ljava/net/HttpURLConnection;

    invoke-virtual {v2}, Ljava/net/HttpURLConnection;->disconnect()V
    :try_end_1
    .catch Lorg/apache/http/client/ClientProtocolException; {:try_start_1 .. :try_end_1} :catch_3
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_2
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    :goto_2
    iget-boolean v2, p0, Lcn/uc/a/a/a/a/b/b;->v:Z

    if-eqz v2, :cond_1

    iput v5, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    move-object v0, v1

    :cond_1
    iput-boolean v6, p0, Lcn/uc/a/a/a/a/b/b;->v:Z

    iput-object v1, p0, Lcn/uc/a/a/a/a/b/b;->t:Ljava/net/HttpURLConnection;

    iput-object v1, p0, Lcn/uc/a/a/a/a/b/b;->u:Lorg/apache/http/client/HttpClient;

    :goto_3
    move-object v1, v0

    goto/16 :goto_0

    :cond_2
    :try_start_2
    const-string v0, "http.proxyHost"

    invoke-static {v0}, Ljava/lang/System;->clearProperty(Ljava/lang/String;)Ljava/lang/String;

    const-string v0, "http.proxyPort"

    invoke-static {v0}, Ljava/lang/System;->clearProperty(Ljava/lang/String;)Ljava/lang/String;
    :try_end_2
    .catch Lorg/apache/http/client/ClientProtocolException; {:try_start_2 .. :try_end_2} :catch_0
    .catch Ljava/io/IOException; {:try_start_2 .. :try_end_2} :catch_1
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    goto :goto_1

    :catch_0
    move-exception v0

    move-object v2, v0

    move-object v0, v1

    :goto_4
    :try_start_3
    iget-boolean v3, p0, Lcn/uc/a/a/a/a/b/b;->v:Z

    if-eqz v3, :cond_6

    const-string v2, "HttpConnection"

    const-string v3, "getBodyStrByPostHttpUrlConnection"

    const-string v4, "\u4e3b\u52a8\u65ad\u5f00HTTP\u8fde\u63a5"

    invoke-static {v2, v3, v4}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const/4 v2, -0x4

    iput v2, p0, Lcn/uc/a/a/a/a/b/b;->l:I
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    iget-boolean v2, p0, Lcn/uc/a/a/a/a/b/b;->v:Z

    if-eqz v2, :cond_3

    iput v5, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    move-object v0, v1

    :cond_3
    iput-boolean v6, p0, Lcn/uc/a/a/a/a/b/b;->v:Z

    iput-object v1, p0, Lcn/uc/a/a/a/a/b/b;->t:Ljava/net/HttpURLConnection;

    iput-object v1, p0, Lcn/uc/a/a/a/a/b/b;->u:Lorg/apache/http/client/HttpClient;

    goto :goto_3

    :cond_4
    :try_start_4
    const-string v0, "http.proxyHost"

    invoke-static {v0}, Ljava/lang/System;->clearProperty(Ljava/lang/String;)Ljava/lang/String;

    const-string v0, "http.proxyPort"

    invoke-static {v0}, Ljava/lang/System;->clearProperty(Ljava/lang/String;)Ljava/lang/String;
    :try_end_4
    .catch Lorg/apache/http/client/ClientProtocolException; {:try_start_4 .. :try_end_4} :catch_0
    .catch Ljava/io/IOException; {:try_start_4 .. :try_end_4} :catch_1
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    goto :goto_1

    :catch_1
    move-exception v0

    move-object v2, v0

    move-object v0, v1

    :goto_5
    :try_start_5
    iget-boolean v3, p0, Lcn/uc/a/a/a/a/b/b;->v:Z

    if-eqz v3, :cond_8

    const-string v2, "HttpConnection"

    const-string v3, "getBodyStrByPostHttpUrlConnection"

    const-string v4, "\u4e3b\u52a8\u65ad\u5f00HTTP\u8fde\u63a5"

    invoke-static {v2, v3, v4}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const/4 v2, -0x4

    iput v2, p0, Lcn/uc/a/a/a/a/b/b;->l:I
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_0

    iget-boolean v2, p0, Lcn/uc/a/a/a/a/b/b;->v:Z

    if-eqz v2, :cond_5

    iput v5, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    move-object v0, v1

    :cond_5
    iput-boolean v6, p0, Lcn/uc/a/a/a/a/b/b;->v:Z

    iput-object v1, p0, Lcn/uc/a/a/a/a/b/b;->t:Ljava/net/HttpURLConnection;

    iput-object v1, p0, Lcn/uc/a/a/a/a/b/b;->u:Lorg/apache/http/client/HttpClient;

    goto :goto_3

    :cond_6
    :try_start_6
    throw v2
    :try_end_6
    .catchall {:try_start_6 .. :try_end_6} :catchall_0

    :catchall_0
    move-exception v0

    iget-boolean v2, p0, Lcn/uc/a/a/a/a/b/b;->v:Z

    if-eqz v2, :cond_7

    iput v5, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    :cond_7
    iput-boolean v6, p0, Lcn/uc/a/a/a/a/b/b;->v:Z

    iput-object v1, p0, Lcn/uc/a/a/a/a/b/b;->t:Ljava/net/HttpURLConnection;

    iput-object v1, p0, Lcn/uc/a/a/a/a/b/b;->u:Lorg/apache/http/client/HttpClient;

    throw v0

    :cond_8
    :try_start_7
    throw v2
    :try_end_7
    .catchall {:try_start_7 .. :try_end_7} :catchall_0

    :catch_2
    move-exception v2

    goto :goto_5

    :catch_3
    move-exception v2

    goto :goto_4

    :cond_9
    move-object v0, v1

    goto :goto_2
.end method


# virtual methods
.method public a()I
    .locals 1

    iget v0, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    return v0
.end method

.method public a(Ljava/lang/String;Ljava/util/HashMap;)Ljava/lang/String;
    .locals 13
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "Ljava/util/HashMap",
            "<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;)",
            "Ljava/lang/String;"
        }
    .end annotation

    const/4 v12, -0x2

    const/4 v2, 0x0

    const-string v0, ""

    iget-object v1, p0, Lcn/uc/a/a/a/a/b/b;->k:Landroid/content/Context;

    invoke-static {v1}, Lcn/uc/a/a/a/b/a;->j(Landroid/content/Context;)Z

    move-result v3

    if-nez v3, :cond_0

    const/4 v0, -0x1

    iput v0, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    const-string v0, ""

    :goto_0
    return-object v0

    :cond_0
    const-string v7, ""

    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0, p1, p2}, Lcn/uc/a/a/a/a/b/b;->c(Ljava/lang/String;Ljava/util/HashMap;)Ljava/lang/String;

    move-result-object v5

    const-string v3, "HttpConnection"

    const-string v4, "getBodyStrByGet"

    invoke-static {v3, v4, v5}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v3, "Http Request Get UrlAddr:"

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v3, "\n"

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    :try_start_0
    iget-object v0, p0, Lcn/uc/a/a/a/a/b/b;->i:Ljava/lang/String;

    invoke-static {v1, v0}, Lcn/uc/a/a/a/a/b/b;->a(Landroid/content/Context;Ljava/lang/String;)Lorg/apache/http/impl/client/DefaultHttpClient;
    :try_end_0
    .catch Lorg/apache/http/client/ClientProtocolException; {:try_start_0 .. :try_end_0} :catch_14
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_11
    .catch Ljava/lang/IllegalStateException; {:try_start_0 .. :try_end_0} :catch_6
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_8
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    move-result-object v1

    :try_start_1
    invoke-interface {v1}, Lorg/apache/http/client/HttpClient;->getParams()Lorg/apache/http/params/HttpParams;

    move-result-object v0

    iget-object v3, p0, Lcn/uc/a/a/a/a/b/b;->j:Lorg/apache/http/HttpHost;

    if-eqz v3, :cond_4

    const-string v3, "http.route.default-proxy"

    iget-object v4, p0, Lcn/uc/a/a/a/a/b/b;->j:Lorg/apache/http/HttpHost;

    invoke-interface {v0, v3, v4}, Lorg/apache/http/params/HttpParams;->setParameter(Ljava/lang/String;Ljava/lang/Object;)Lorg/apache/http/params/HttpParams;

    const-string v3, "HttpConnection"

    const-string v4, "getBodyStrByGet"

    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v9, p0, Lcn/uc/a/a/a/a/b/b;->j:Lorg/apache/http/HttpHost;

    invoke-virtual {v9}, Lorg/apache/http/HttpHost;->getHostName()Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v8

    const-string v9, ","

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v8

    iget-object v9, p0, Lcn/uc/a/a/a/a/b/b;->j:Lorg/apache/http/HttpHost;

    invoke-virtual {v9}, Lorg/apache/http/HttpHost;->getPort()I

    move-result v9

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v8

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    invoke-static {v3, v4, v8}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :goto_1
    iget-object v3, p0, Lcn/uc/a/a/a/a/b/b;->i:Ljava/lang/String;

    invoke-virtual {v3}, Ljava/lang/String;->length()I

    move-result v3

    if-lez v3, :cond_5

    const-string v3, "http.useragent"

    iget-object v4, p0, Lcn/uc/a/a/a/a/b/b;->i:Ljava/lang/String;

    invoke-interface {v0, v3, v4}, Lorg/apache/http/params/HttpParams;->setParameter(Ljava/lang/String;Ljava/lang/Object;)Lorg/apache/http/params/HttpParams;

    const-string v0, "HttpConnection"

    const-string v3, "getBodyStrByGet"

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v8, "User-agent :"

    invoke-virtual {v4, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    iget-object v8, p0, Lcn/uc/a/a/a/a/b/b;->i:Ljava/lang/String;

    invoke-virtual {v4, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v0, v3, v4}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :goto_2
    new-instance v0, Lorg/apache/http/client/methods/HttpGet;

    invoke-direct {v0, v5}, Lorg/apache/http/client/methods/HttpGet;-><init>(Ljava/lang/String;)V

    const-string v3, "Accept"

    const-string v4, "*/*"

    invoke-virtual {v0, v3, v4}, Lorg/apache/http/client/methods/HttpGet;->addHeader(Ljava/lang/String;Ljava/lang/String;)V

    const-string v3, "Accept-Encoding"

    const-string v4, "application/x-www-form-urlencoded"

    invoke-virtual {v0, v3, v4}, Lorg/apache/http/client/methods/HttpGet;->setHeader(Ljava/lang/String;Ljava/lang/String;)V

    invoke-direct {p0, v5}, Lcn/uc/a/a/a/a/b/b;->c(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    if-eqz v3, :cond_1

    invoke-virtual {v3}, Ljava/lang/String;->length()I

    move-result v4

    if-lez v4, :cond_1

    const-string v4, "Cookie"

    invoke-virtual {v0, v4, v3}, Lorg/apache/http/client/methods/HttpGet;->setHeader(Ljava/lang/String;Ljava/lang/String;)V

    :cond_1
    invoke-interface {v1, v0}, Lorg/apache/http/client/HttpClient;->execute(Lorg/apache/http/client/methods/HttpUriRequest;)Lorg/apache/http/HttpResponse;
    :try_end_1
    .catch Lorg/apache/http/client/ClientProtocolException; {:try_start_1 .. :try_end_1} :catch_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_2
    .catch Ljava/lang/IllegalStateException; {:try_start_1 .. :try_end_1} :catch_e
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_b
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    move-result-object v3

    :try_start_2
    invoke-interface {v3}, Lorg/apache/http/HttpResponse;->getEntity()Lorg/apache/http/HttpEntity;

    move-result-object v0

    new-instance v4, Ljava/io/BufferedReader;

    new-instance v8, Ljava/io/InputStreamReader;

    invoke-interface {v0}, Lorg/apache/http/HttpEntity;->getContent()Ljava/io/InputStream;

    move-result-object v0

    invoke-direct {v8, v0}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;)V

    const/16 v0, 0x400

    invoke-direct {v4, v8, v0}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;I)V
    :try_end_2
    .catch Lorg/apache/http/client/ClientProtocolException; {:try_start_2 .. :try_end_2} :catch_15
    .catch Ljava/io/IOException; {:try_start_2 .. :try_end_2} :catch_12
    .catch Ljava/lang/IllegalStateException; {:try_start_2 .. :try_end_2} :catch_f
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_c
    .catchall {:try_start_2 .. :try_end_2} :catchall_2

    :goto_3
    :try_start_3
    invoke-virtual {v4}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_7

    invoke-virtual {v11, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "\r\n"

    invoke-virtual {v11, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :try_end_3
    .catch Lorg/apache/http/client/ClientProtocolException; {:try_start_3 .. :try_end_3} :catch_0
    .catch Ljava/io/IOException; {:try_start_3 .. :try_end_3} :catch_13
    .catch Ljava/lang/IllegalStateException; {:try_start_3 .. :try_end_3} :catch_10
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_d
    .catchall {:try_start_3 .. :try_end_3} :catchall_3

    goto :goto_3

    :catch_0
    move-exception v0

    move-object v8, v1

    move-object v9, v3

    move-object v10, v4

    move-object v3, v0

    :goto_4
    :try_start_4
    const-string v0, "HttpConnection"

    const-string v1, "getBodyStrByGet"

    const-string v2, "network"

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v3}, Lorg/apache/http/client/ClientProtocolException;->toString()Ljava/lang/String;

    move-result-object v3

    const-string v5, "\n|\r"

    invoke-virtual {v3, v5}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v3

    const/4 v5, 0x0

    aget-object v3, v3, v5

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    const/4 v4, 0x0

    const/4 v5, 0x2

    const-string v6, "key_mve"

    invoke-static {v6}, Lcn/uc/a/a/a/a;->c(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    invoke-static/range {v0 .. v6}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;ILjava/lang/String;)V
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_4

    if-eqz v9, :cond_a

    invoke-interface {v9}, Lorg/apache/http/HttpResponse;->getStatusLine()Lorg/apache/http/StatusLine;

    move-result-object v0

    invoke-interface {v0}, Lorg/apache/http/StatusLine;->getStatusCode()I

    move-result v0

    iput v0, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iget v0, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iput v0, p0, Lcn/uc/a/a/a/a/b/b;->s:I

    :goto_5
    if-eqz v10, :cond_2

    :try_start_5
    invoke-virtual {v10}, Ljava/io/BufferedReader;->close()V
    :try_end_5
    .catch Ljava/io/IOException; {:try_start_5 .. :try_end_5} :catch_4

    :cond_2
    :goto_6
    if-eqz v8, :cond_14

    invoke-interface {v8}, Lorg/apache/http/client/HttpClient;->getConnectionManager()Lorg/apache/http/conn/ClientConnectionManager;

    move-result-object v0

    invoke-interface {v0}, Lorg/apache/http/conn/ClientConnectionManager;->shutdown()V

    move-object v0, v7

    :cond_3
    :goto_7
    const-string v1, "HttpConnection"

    const-string v2, "getBodyStrByGet"

    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v1, v2, v3}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    if-eqz v0, :cond_13

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v1

    if-lez v1, :cond_13

    new-instance v1, Ljava/util/HashMap;

    invoke-direct {v1}, Ljava/util/HashMap;-><init>()V

    invoke-virtual {p0, v0, v1}, Lcn/uc/a/a/a/a/b/b;->a(Ljava/lang/String;Ljava/util/HashMap;)Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_0

    :cond_4
    :try_start_6
    const-string v3, "HttpConnection"

    const-string v4, "getBodyStrByGet"

    const-string v8, "proxy is null"

    invoke-static {v3, v4, v8}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    goto/16 :goto_1

    :catch_1
    move-exception v0

    move-object v3, v0

    move-object v8, v1

    move-object v9, v2

    move-object v10, v2

    goto :goto_4

    :cond_5
    const-string v0, "HttpConnection"

    const-string v3, "getBodyStrByGet"

    const-string v4, "User-agent null"

    invoke-static {v0, v3, v4}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_6
    .catch Lorg/apache/http/client/ClientProtocolException; {:try_start_6 .. :try_end_6} :catch_1
    .catch Ljava/io/IOException; {:try_start_6 .. :try_end_6} :catch_2
    .catch Ljava/lang/IllegalStateException; {:try_start_6 .. :try_end_6} :catch_e
    .catch Ljava/lang/Exception; {:try_start_6 .. :try_end_6} :catch_b
    .catchall {:try_start_6 .. :try_end_6} :catchall_1

    goto/16 :goto_2

    :catch_2
    move-exception v0

    move-object v3, v0

    move-object v8, v1

    move-object v9, v2

    move-object v10, v2

    :goto_8
    :try_start_7
    const-string v0, "HttpConnection"

    const-string v1, "getBodyStrByGet"

    const-string v2, "network"

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v3}, Ljava/io/IOException;->toString()Ljava/lang/String;

    move-result-object v3

    const-string v5, "\n|\r"

    invoke-virtual {v3, v5}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v3

    const/4 v5, 0x0

    aget-object v3, v3, v5

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    const/4 v4, 0x0

    const/4 v5, 0x2

    const-string v6, "key_mve"

    invoke-static {v6}, Lcn/uc/a/a/a/a;->c(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    invoke-static/range {v0 .. v6}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;ILjava/lang/String;)V
    :try_end_7
    .catchall {:try_start_7 .. :try_end_7} :catchall_4

    if-eqz v9, :cond_b

    invoke-interface {v9}, Lorg/apache/http/HttpResponse;->getStatusLine()Lorg/apache/http/StatusLine;

    move-result-object v0

    invoke-interface {v0}, Lorg/apache/http/StatusLine;->getStatusCode()I

    move-result v0

    iput v0, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iget v0, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iput v0, p0, Lcn/uc/a/a/a/a/b/b;->s:I

    :goto_9
    if-eqz v10, :cond_6

    :try_start_8
    invoke-virtual {v10}, Ljava/io/BufferedReader;->close()V
    :try_end_8
    .catch Ljava/io/IOException; {:try_start_8 .. :try_end_8} :catch_5

    :cond_6
    :goto_a
    if-eqz v8, :cond_14

    invoke-interface {v8}, Lorg/apache/http/client/HttpClient;->getConnectionManager()Lorg/apache/http/conn/ClientConnectionManager;

    move-result-object v0

    invoke-interface {v0}, Lorg/apache/http/conn/ClientConnectionManager;->shutdown()V

    move-object v0, v7

    goto/16 :goto_7

    :cond_7
    :try_start_9
    iget-object v0, p0, Lcn/uc/a/a/a/a/b/b;->u:Lorg/apache/http/client/HttpClient;

    check-cast v0, Lorg/apache/http/impl/client/DefaultHttpClient;

    invoke-virtual {p0, v5, v0}, Lcn/uc/a/a/a/a/b/b;->a(Ljava/lang/String;Lorg/apache/http/impl/client/DefaultHttpClient;)V

    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0, v3, v5}, Lcn/uc/a/a/a/a/b/c;->a(Ljava/lang/String;Lorg/apache/http/HttpResponse;Ljava/lang/String;)Ljava/lang/String;
    :try_end_9
    .catch Lorg/apache/http/client/ClientProtocolException; {:try_start_9 .. :try_end_9} :catch_0
    .catch Ljava/io/IOException; {:try_start_9 .. :try_end_9} :catch_13
    .catch Ljava/lang/IllegalStateException; {:try_start_9 .. :try_end_9} :catch_10
    .catch Ljava/lang/Exception; {:try_start_9 .. :try_end_9} :catch_d
    .catchall {:try_start_9 .. :try_end_9} :catchall_3

    move-result-object v0

    if-eqz v3, :cond_9

    invoke-interface {v3}, Lorg/apache/http/HttpResponse;->getStatusLine()Lorg/apache/http/StatusLine;

    move-result-object v2

    invoke-interface {v2}, Lorg/apache/http/StatusLine;->getStatusCode()I

    move-result v2

    iput v2, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iget v2, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iput v2, p0, Lcn/uc/a/a/a/a/b/b;->s:I

    :goto_b
    if-eqz v4, :cond_8

    :try_start_a
    invoke-virtual {v4}, Ljava/io/BufferedReader;->close()V
    :try_end_a
    .catch Ljava/io/IOException; {:try_start_a .. :try_end_a} :catch_3

    :cond_8
    :goto_c
    if-eqz v1, :cond_3

    invoke-interface {v1}, Lorg/apache/http/client/HttpClient;->getConnectionManager()Lorg/apache/http/conn/ClientConnectionManager;

    move-result-object v1

    invoke-interface {v1}, Lorg/apache/http/conn/ClientConnectionManager;->shutdown()V

    goto/16 :goto_7

    :cond_9
    iput v12, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    goto :goto_b

    :catch_3
    move-exception v2

    invoke-virtual {v2}, Ljava/io/IOException;->printStackTrace()V

    goto :goto_c

    :cond_a
    iput v12, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    goto/16 :goto_5

    :catch_4
    move-exception v0

    invoke-virtual {v0}, Ljava/io/IOException;->printStackTrace()V

    goto/16 :goto_6

    :cond_b
    iput v12, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    goto :goto_9

    :catch_5
    move-exception v0

    invoke-virtual {v0}, Ljava/io/IOException;->printStackTrace()V

    goto :goto_a

    :catch_6
    move-exception v0

    move-object v3, v0

    move-object v8, v2

    move-object v9, v2

    move-object v10, v2

    :goto_d
    :try_start_b
    const-string v0, "HttpConnection"

    const-string v1, "getBodyStrByGet"

    const-string v2, "network"

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v3}, Ljava/lang/IllegalStateException;->toString()Ljava/lang/String;

    move-result-object v3

    const-string v5, "\n|\r"

    invoke-virtual {v3, v5}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v3

    const/4 v5, 0x0

    aget-object v3, v3, v5

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    const/4 v4, 0x0

    const/4 v5, 0x2

    const-string v6, "key_mve"

    invoke-static {v6}, Lcn/uc/a/a/a/a;->c(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    invoke-static/range {v0 .. v6}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;ILjava/lang/String;)V
    :try_end_b
    .catchall {:try_start_b .. :try_end_b} :catchall_4

    if-eqz v9, :cond_d

    invoke-interface {v9}, Lorg/apache/http/HttpResponse;->getStatusLine()Lorg/apache/http/StatusLine;

    move-result-object v0

    invoke-interface {v0}, Lorg/apache/http/StatusLine;->getStatusCode()I

    move-result v0

    iput v0, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iget v0, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iput v0, p0, Lcn/uc/a/a/a/a/b/b;->s:I

    :goto_e
    if-eqz v10, :cond_c

    :try_start_c
    invoke-virtual {v10}, Ljava/io/BufferedReader;->close()V
    :try_end_c
    .catch Ljava/io/IOException; {:try_start_c .. :try_end_c} :catch_7

    :cond_c
    :goto_f
    if-eqz v8, :cond_14

    invoke-interface {v8}, Lorg/apache/http/client/HttpClient;->getConnectionManager()Lorg/apache/http/conn/ClientConnectionManager;

    move-result-object v0

    invoke-interface {v0}, Lorg/apache/http/conn/ClientConnectionManager;->shutdown()V

    move-object v0, v7

    goto/16 :goto_7

    :cond_d
    iput v12, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    goto :goto_e

    :catch_7
    move-exception v0

    invoke-virtual {v0}, Ljava/io/IOException;->printStackTrace()V

    goto :goto_f

    :catch_8
    move-exception v0

    move-object v3, v0

    move-object v8, v2

    move-object v9, v2

    move-object v10, v2

    :goto_10
    :try_start_d
    const-string v0, "HttpConnection"

    const-string v1, "getBodyStrByGet"

    const-string v2, "network"

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v3}, Ljava/lang/Exception;->toString()Ljava/lang/String;

    move-result-object v3

    const-string v5, "\n|\r"

    invoke-virtual {v3, v5}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v3

    const/4 v5, 0x0

    aget-object v3, v3, v5

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    const/4 v4, 0x0

    const/4 v5, 0x2

    const-string v6, "key_mve"

    invoke-static {v6}, Lcn/uc/a/a/a/a;->c(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    invoke-static/range {v0 .. v6}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;ILjava/lang/String;)V
    :try_end_d
    .catchall {:try_start_d .. :try_end_d} :catchall_4

    if-eqz v9, :cond_f

    invoke-interface {v9}, Lorg/apache/http/HttpResponse;->getStatusLine()Lorg/apache/http/StatusLine;

    move-result-object v0

    invoke-interface {v0}, Lorg/apache/http/StatusLine;->getStatusCode()I

    move-result v0

    iput v0, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iget v0, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iput v0, p0, Lcn/uc/a/a/a/a/b/b;->s:I

    :goto_11
    if-eqz v10, :cond_e

    :try_start_e
    invoke-virtual {v10}, Ljava/io/BufferedReader;->close()V
    :try_end_e
    .catch Ljava/io/IOException; {:try_start_e .. :try_end_e} :catch_9

    :cond_e
    :goto_12
    if-eqz v8, :cond_14

    invoke-interface {v8}, Lorg/apache/http/client/HttpClient;->getConnectionManager()Lorg/apache/http/conn/ClientConnectionManager;

    move-result-object v0

    invoke-interface {v0}, Lorg/apache/http/conn/ClientConnectionManager;->shutdown()V

    move-object v0, v7

    goto/16 :goto_7

    :cond_f
    iput v12, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    goto :goto_11

    :catch_9
    move-exception v0

    invoke-virtual {v0}, Ljava/io/IOException;->printStackTrace()V

    goto :goto_12

    :catchall_0
    move-exception v0

    move-object v1, v2

    move-object v9, v2

    :goto_13
    if-eqz v9, :cond_12

    invoke-interface {v9}, Lorg/apache/http/HttpResponse;->getStatusLine()Lorg/apache/http/StatusLine;

    move-result-object v3

    invoke-interface {v3}, Lorg/apache/http/StatusLine;->getStatusCode()I

    move-result v3

    iput v3, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iget v3, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iput v3, p0, Lcn/uc/a/a/a/a/b/b;->s:I

    :goto_14
    if-eqz v2, :cond_10

    :try_start_f
    invoke-virtual {v2}, Ljava/io/BufferedReader;->close()V
    :try_end_f
    .catch Ljava/io/IOException; {:try_start_f .. :try_end_f} :catch_a

    :cond_10
    :goto_15
    if-eqz v1, :cond_11

    invoke-interface {v1}, Lorg/apache/http/client/HttpClient;->getConnectionManager()Lorg/apache/http/conn/ClientConnectionManager;

    move-result-object v1

    invoke-interface {v1}, Lorg/apache/http/conn/ClientConnectionManager;->shutdown()V

    :cond_11
    throw v0

    :cond_12
    iput v12, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    goto :goto_14

    :catch_a
    move-exception v2

    invoke-virtual {v2}, Ljava/io/IOException;->printStackTrace()V

    goto :goto_15

    :cond_13
    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_0

    :catchall_1
    move-exception v0

    move-object v9, v2

    goto :goto_13

    :catchall_2
    move-exception v0

    move-object v9, v3

    goto :goto_13

    :catchall_3
    move-exception v0

    move-object v9, v3

    move-object v2, v4

    goto :goto_13

    :catchall_4
    move-exception v0

    move-object v1, v8

    move-object v2, v10

    goto :goto_13

    :catch_b
    move-exception v0

    move-object v3, v0

    move-object v8, v1

    move-object v9, v2

    move-object v10, v2

    goto/16 :goto_10

    :catch_c
    move-exception v0

    move-object v8, v1

    move-object v9, v3

    move-object v10, v2

    move-object v3, v0

    goto/16 :goto_10

    :catch_d
    move-exception v0

    move-object v8, v1

    move-object v9, v3

    move-object v10, v4

    move-object v3, v0

    goto/16 :goto_10

    :catch_e
    move-exception v0

    move-object v3, v0

    move-object v8, v1

    move-object v9, v2

    move-object v10, v2

    goto/16 :goto_d

    :catch_f
    move-exception v0

    move-object v8, v1

    move-object v9, v3

    move-object v10, v2

    move-object v3, v0

    goto/16 :goto_d

    :catch_10
    move-exception v0

    move-object v8, v1

    move-object v9, v3

    move-object v10, v4

    move-object v3, v0

    goto/16 :goto_d

    :catch_11
    move-exception v0

    move-object v3, v0

    move-object v8, v2

    move-object v9, v2

    move-object v10, v2

    goto/16 :goto_8

    :catch_12
    move-exception v0

    move-object v8, v1

    move-object v9, v3

    move-object v10, v2

    move-object v3, v0

    goto/16 :goto_8

    :catch_13
    move-exception v0

    move-object v8, v1

    move-object v9, v3

    move-object v10, v4

    move-object v3, v0

    goto/16 :goto_8

    :catch_14
    move-exception v0

    move-object v3, v0

    move-object v8, v2

    move-object v9, v2

    move-object v10, v2

    goto/16 :goto_4

    :catch_15
    move-exception v0

    move-object v8, v1

    move-object v9, v3

    move-object v10, v2

    move-object v3, v0

    goto/16 :goto_4

    :cond_14
    move-object v0, v7

    goto/16 :goto_7
.end method

.method public a(Ljava/lang/String;)Lorg/apache/http/HttpResponse;
    .locals 10

    const/4 v7, 0x0

    const/4 v9, -0x2

    iget-object v0, p0, Lcn/uc/a/a/a/a/b/b;->k:Landroid/content/Context;

    invoke-static {v0}, Lcn/uc/a/a/a/b/a;->j(Landroid/content/Context;)Z

    move-result v1

    if-nez v1, :cond_0

    const/4 v1, -0x1

    iput v1, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    :cond_0
    if-eqz p1, :cond_1

    invoke-virtual {p0, p1}, Lcn/uc/a/a/a/a/b/b;->b(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    :cond_1
    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "HttpConnection"

    const-string v2, "getResponseByHead"

    invoke-static {v1, v2, p1}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :try_start_0
    iget-object v1, p0, Lcn/uc/a/a/a/a/b/b;->i:Ljava/lang/String;

    invoke-static {v0, v1}, Lcn/uc/a/a/a/a/b/b;->a(Landroid/content/Context;Ljava/lang/String;)Lorg/apache/http/impl/client/DefaultHttpClient;

    move-result-object v1

    invoke-interface {v1}, Lorg/apache/http/client/HttpClient;->getParams()Lorg/apache/http/params/HttpParams;

    move-result-object v0

    iget-object v2, p0, Lcn/uc/a/a/a/a/b/b;->j:Lorg/apache/http/HttpHost;

    if-eqz v2, :cond_2

    const-string v2, "http.route.default-proxy"

    iget-object v3, p0, Lcn/uc/a/a/a/a/b/b;->j:Lorg/apache/http/HttpHost;

    invoke-interface {v0, v2, v3}, Lorg/apache/http/params/HttpParams;->setParameter(Ljava/lang/String;Ljava/lang/Object;)Lorg/apache/http/params/HttpParams;

    const-string v2, "HttpConnection"

    const-string v3, "getResponseByHead"

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v5, p0, Lcn/uc/a/a/a/a/b/b;->j:Lorg/apache/http/HttpHost;

    invoke-virtual {v5}, Lorg/apache/http/HttpHost;->getHostName()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, ","

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    iget-object v5, p0, Lcn/uc/a/a/a/a/b/b;->j:Lorg/apache/http/HttpHost;

    invoke-virtual {v5}, Lorg/apache/http/HttpHost;->getPort()I

    move-result v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v2, v3, v4}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :goto_0
    iget-object v2, p0, Lcn/uc/a/a/a/a/b/b;->i:Ljava/lang/String;

    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v2

    if-lez v2, :cond_3

    const-string v2, "http.useragent"

    iget-object v3, p0, Lcn/uc/a/a/a/a/b/b;->i:Ljava/lang/String;

    invoke-interface {v0, v2, v3}, Lorg/apache/http/params/HttpParams;->setParameter(Ljava/lang/String;Ljava/lang/Object;)Lorg/apache/http/params/HttpParams;

    const-string v0, "HttpConnection"

    const-string v2, "getResponseByHead"

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "User-agent :"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    iget-object v4, p0, Lcn/uc/a/a/a/a/b/b;->i:Ljava/lang/String;

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v0, v2, v3}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :goto_1
    new-instance v0, Lorg/apache/http/client/methods/HttpHead;

    invoke-direct {v0, p1}, Lorg/apache/http/client/methods/HttpHead;-><init>(Ljava/lang/String;)V

    const-string v2, "Accept-Encoding"

    const-string v3, "application/x-www-form-urlencoded"

    invoke-virtual {v0, v2, v3}, Lorg/apache/http/client/methods/HttpHead;->setHeader(Ljava/lang/String;Ljava/lang/String;)V

    invoke-interface {v1, v0}, Lorg/apache/http/client/HttpClient;->execute(Lorg/apache/http/client/methods/HttpUriRequest;)Lorg/apache/http/HttpResponse;
    :try_end_0
    .catch Lorg/apache/http/client/ClientProtocolException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/IllegalStateException; {:try_start_0 .. :try_end_0} :catch_2
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_3
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    move-result-object v0

    :try_start_1
    invoke-interface {v1}, Lorg/apache/http/client/HttpClient;->getConnectionManager()Lorg/apache/http/conn/ClientConnectionManager;

    move-result-object v1

    invoke-interface {v1}, Lorg/apache/http/conn/ClientConnectionManager;->shutdown()V
    :try_end_1
    .catch Lorg/apache/http/client/ClientProtocolException; {:try_start_1 .. :try_end_1} :catch_7
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_6
    .catch Ljava/lang/IllegalStateException; {:try_start_1 .. :try_end_1} :catch_5
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_4
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    if-eqz v0, :cond_4

    invoke-interface {v0}, Lorg/apache/http/HttpResponse;->getStatusLine()Lorg/apache/http/StatusLine;

    move-result-object v1

    invoke-interface {v1}, Lorg/apache/http/StatusLine;->getStatusCode()I

    move-result v1

    iput v1, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iget v1, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iput v1, p0, Lcn/uc/a/a/a/a/b/b;->s:I

    :goto_2
    const-string v1, "HttpConnection"

    const-string v2, "getResponseByHead"

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v1, v2, v3}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return-object v0

    :cond_2
    :try_start_2
    const-string v2, "HttpConnection"

    const-string v3, "getResponseByHead"

    const-string v4, "proxy is null"

    invoke-static {v2, v3, v4}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_2
    .catch Lorg/apache/http/client/ClientProtocolException; {:try_start_2 .. :try_end_2} :catch_0
    .catch Ljava/io/IOException; {:try_start_2 .. :try_end_2} :catch_1
    .catch Ljava/lang/IllegalStateException; {:try_start_2 .. :try_end_2} :catch_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_3
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    goto :goto_0

    :catch_0
    move-exception v0

    move-object v3, v0

    :goto_3
    :try_start_3
    const-string v0, "HttpConnection"

    const-string v1, "getResponseByHead"

    const-string v2, "network"

    invoke-virtual {v3}, Lorg/apache/http/client/ClientProtocolException;->toString()Ljava/lang/String;

    move-result-object v3

    const-string v4, "\n|\r"

    invoke-virtual {v3, v4}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v3

    const/4 v4, 0x0

    aget-object v3, v3, v4

    const/4 v4, 0x0

    const/4 v5, 0x2

    const-string v6, "key_mve"

    invoke-static {v6}, Lcn/uc/a/a/a/a;->c(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    invoke-static/range {v0 .. v6}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;ILjava/lang/String;)V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    if-eqz v7, :cond_5

    invoke-interface {v7}, Lorg/apache/http/HttpResponse;->getStatusLine()Lorg/apache/http/StatusLine;

    move-result-object v0

    invoke-interface {v0}, Lorg/apache/http/StatusLine;->getStatusCode()I

    move-result v0

    iput v0, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iget v0, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iput v0, p0, Lcn/uc/a/a/a/a/b/b;->s:I

    move-object v0, v7

    goto :goto_2

    :cond_3
    :try_start_4
    const-string v0, "HttpConnection"

    const-string v2, "getResponseByHead"

    const-string v3, "User-agent null"

    invoke-static {v0, v2, v3}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_4
    .catch Lorg/apache/http/client/ClientProtocolException; {:try_start_4 .. :try_end_4} :catch_0
    .catch Ljava/io/IOException; {:try_start_4 .. :try_end_4} :catch_1
    .catch Ljava/lang/IllegalStateException; {:try_start_4 .. :try_end_4} :catch_2
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_3
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    goto :goto_1

    :catch_1
    move-exception v0

    move-object v3, v0

    :goto_4
    :try_start_5
    const-string v0, "HttpConnection"

    const-string v1, "getResponseByHead"

    const-string v2, "network"

    invoke-virtual {v3}, Ljava/io/IOException;->toString()Ljava/lang/String;

    move-result-object v3

    const-string v4, "\n|\r"

    invoke-virtual {v3, v4}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v3

    const/4 v4, 0x0

    aget-object v3, v3, v4

    const/4 v4, 0x0

    const/4 v5, 0x2

    const-string v6, "key_mve"

    invoke-static {v6}, Lcn/uc/a/a/a/a;->c(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    invoke-static/range {v0 .. v6}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;ILjava/lang/String;)V
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_0

    if-eqz v7, :cond_6

    invoke-interface {v7}, Lorg/apache/http/HttpResponse;->getStatusLine()Lorg/apache/http/StatusLine;

    move-result-object v0

    invoke-interface {v0}, Lorg/apache/http/StatusLine;->getStatusCode()I

    move-result v0

    iput v0, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iget v0, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iput v0, p0, Lcn/uc/a/a/a/a/b/b;->s:I

    move-object v0, v7

    goto/16 :goto_2

    :cond_4
    iput v9, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    goto/16 :goto_2

    :cond_5
    iput v9, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    move-object v0, v7

    goto/16 :goto_2

    :cond_6
    iput v9, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    move-object v0, v7

    goto/16 :goto_2

    :catch_2
    move-exception v0

    move-object v3, v0

    :goto_5
    :try_start_6
    const-string v0, "HttpConnection"

    const-string v1, "getResponseByHead"

    const-string v2, "network"

    invoke-virtual {v3}, Ljava/lang/IllegalStateException;->toString()Ljava/lang/String;

    move-result-object v3

    const-string v4, "\n|\r"

    invoke-virtual {v3, v4}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v3

    const/4 v4, 0x0

    aget-object v3, v3, v4

    const/4 v4, 0x0

    const/4 v5, 0x2

    const-string v6, "key_mve"

    invoke-static {v6}, Lcn/uc/a/a/a/a;->c(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    invoke-static/range {v0 .. v6}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;ILjava/lang/String;)V
    :try_end_6
    .catchall {:try_start_6 .. :try_end_6} :catchall_0

    if-eqz v7, :cond_7

    invoke-interface {v7}, Lorg/apache/http/HttpResponse;->getStatusLine()Lorg/apache/http/StatusLine;

    move-result-object v0

    invoke-interface {v0}, Lorg/apache/http/StatusLine;->getStatusCode()I

    move-result v0

    iput v0, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iget v0, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iput v0, p0, Lcn/uc/a/a/a/a/b/b;->s:I

    move-object v0, v7

    goto/16 :goto_2

    :cond_7
    iput v9, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    move-object v0, v7

    goto/16 :goto_2

    :catch_3
    move-exception v0

    move-object v3, v0

    :goto_6
    :try_start_7
    const-string v0, "HttpConnection"

    const-string v1, "getResponseByHead"

    const-string v2, "network"

    invoke-virtual {v3}, Ljava/lang/Exception;->toString()Ljava/lang/String;

    move-result-object v3

    const-string v4, "\n|\r"

    invoke-virtual {v3, v4}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v3

    const/4 v4, 0x0

    aget-object v3, v3, v4

    const/4 v4, 0x0

    const/4 v5, 0x2

    const-string v6, "key_mve"

    invoke-static {v6}, Lcn/uc/a/a/a/a;->c(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    invoke-static/range {v0 .. v6}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;ILjava/lang/String;)V
    :try_end_7
    .catchall {:try_start_7 .. :try_end_7} :catchall_0

    if-eqz v7, :cond_8

    invoke-interface {v7}, Lorg/apache/http/HttpResponse;->getStatusLine()Lorg/apache/http/StatusLine;

    move-result-object v0

    invoke-interface {v0}, Lorg/apache/http/StatusLine;->getStatusCode()I

    move-result v0

    iput v0, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iget v0, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iput v0, p0, Lcn/uc/a/a/a/a/b/b;->s:I

    move-object v0, v7

    goto/16 :goto_2

    :cond_8
    iput v9, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    move-object v0, v7

    goto/16 :goto_2

    :catchall_0
    move-exception v0

    :goto_7
    if-eqz v7, :cond_9

    invoke-interface {v7}, Lorg/apache/http/HttpResponse;->getStatusLine()Lorg/apache/http/StatusLine;

    move-result-object v1

    invoke-interface {v1}, Lorg/apache/http/StatusLine;->getStatusCode()I

    move-result v1

    iput v1, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iget v1, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iput v1, p0, Lcn/uc/a/a/a/a/b/b;->s:I

    :goto_8
    throw v0

    :cond_9
    iput v9, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    goto :goto_8

    :catchall_1
    move-exception v1

    move-object v7, v0

    move-object v0, v1

    goto :goto_7

    :catch_4
    move-exception v1

    move-object v3, v1

    move-object v7, v0

    goto :goto_6

    :catch_5
    move-exception v1

    move-object v3, v1

    move-object v7, v0

    goto/16 :goto_5

    :catch_6
    move-exception v1

    move-object v3, v1

    move-object v7, v0

    goto/16 :goto_4

    :catch_7
    move-exception v1

    move-object v3, v1

    move-object v7, v0

    goto/16 :goto_3
.end method

.method public a(Ljava/lang/String;Lorg/apache/http/impl/client/DefaultHttpClient;)V
    .locals 5

    invoke-static {}, Lcn/uc/a/a/a/a;->a()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Landroid/webkit/CookieSyncManager;->createInstance(Landroid/content/Context;)Landroid/webkit/CookieSyncManager;

    invoke-static {}, Landroid/webkit/CookieManager;->getInstance()Landroid/webkit/CookieManager;

    move-result-object v2

    const/4 v0, 0x1

    invoke-virtual {v2, v0}, Landroid/webkit/CookieManager;->setAcceptCookie(Z)V

    invoke-virtual {p2}, Lorg/apache/http/impl/client/DefaultHttpClient;->getCookieStore()Lorg/apache/http/client/CookieStore;

    move-result-object v0

    invoke-interface {v0}, Lorg/apache/http/client/CookieStore;->getCookies()Ljava/util/List;

    move-result-object v1

    const-string v0, ""

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    move-object v1, v0

    :goto_0
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_4

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/apache/http/cookie/Cookie;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-interface {v0}, Lorg/apache/http/cookie/Cookie;->getName()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v4, "="

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-interface {v0}, Lorg/apache/http/cookie/Cookie;->getValue()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-interface {v0}, Lorg/apache/http/cookie/Cookie;->getDomain()Ljava/lang/String;

    move-result-object v4

    if-eqz v4, :cond_0

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v4, "; Domain="

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-interface {v0}, Lorg/apache/http/cookie/Cookie;->getDomain()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    :cond_0
    invoke-interface {v0}, Lorg/apache/http/cookie/Cookie;->getPath()Ljava/lang/String;

    move-result-object v4

    if-eqz v4, :cond_1

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v4, "; Path="

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-interface {v0}, Lorg/apache/http/cookie/Cookie;->getPath()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    :cond_1
    invoke-interface {v0}, Lorg/apache/http/cookie/Cookie;->getExpiryDate()Ljava/util/Date;

    move-result-object v4

    if-eqz v4, :cond_2

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v4, "; Expires="

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-interface {v0}, Lorg/apache/http/cookie/Cookie;->getExpiryDate()Ljava/util/Date;

    move-result-object v0

    invoke-virtual {v0}, Ljava/util/Date;->toGMTString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    :cond_2
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, ";"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v1

    if-lez v1, :cond_3

    const/4 v1, 0x0

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v4

    add-int/lit8 v4, v4, -0x1

    invoke-virtual {v0, v1, v4}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0

    :cond_3
    invoke-virtual {v2, p1, v0}, Landroid/webkit/CookieManager;->setCookie(Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v2}, Landroid/webkit/CookieManager;->removeExpiredCookie()V

    invoke-static {}, Landroid/webkit/CookieSyncManager;->getInstance()Landroid/webkit/CookieSyncManager;

    move-result-object v1

    invoke-virtual {v1}, Landroid/webkit/CookieSyncManager;->sync()V

    move-object v1, v0

    goto/16 :goto_0

    :cond_4
    return-void
.end method

.method public a(Ljava/lang/String;[B)[B
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/apache/http/client/ClientProtocolException;,
            Ljava/io/IOException;
        }
    .end annotation

    sget-object v0, Landroid/os/Build$VERSION;->SDK:Ljava/lang/String;

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v0

    const/16 v1, 0x9

    if-lt v0, v1, :cond_0

    invoke-direct {p0, p1, p2}, Lcn/uc/a/a/a/a/b/b;->c(Ljava/lang/String;[B)[B

    move-result-object v0

    :goto_0
    return-object v0

    :cond_0
    iget-object v0, p0, Lcn/uc/a/a/a/a/b/b;->k:Landroid/content/Context;

    invoke-static {v0}, Lcn/uc/a/a/a/b/a;->f(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-direct {p0, p1, p2}, Lcn/uc/a/a/a/a/b/b;->b(Ljava/lang/String;[B)[B

    move-result-object v0

    goto :goto_0

    :cond_1
    sget-object v0, Landroid/os/Build$VERSION;->SDK:Ljava/lang/String;

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v0

    const/4 v1, 0x7

    if-gt v0, v1, :cond_2

    invoke-direct {p0, p1, p2}, Lcn/uc/a/a/a/a/b/b;->b(Ljava/lang/String;[B)[B

    move-result-object v0

    goto :goto_0

    :cond_2
    invoke-direct {p0, p1, p2}, Lcn/uc/a/a/a/a/b/b;->c(Ljava/lang/String;[B)[B

    move-result-object v0

    goto :goto_0
.end method

.method public b()I
    .locals 1

    iget v0, p0, Lcn/uc/a/a/a/a/b/b;->s:I

    return v0
.end method

.method public b(Ljava/lang/String;)Ljava/lang/String;
    .locals 3

    invoke-static {p1}, Landroid/webkit/URLUtil;->isHttpsUrl(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_1

    :try_start_0
    new-instance v1, Ljava/net/URL;

    invoke-direct {v1, p1}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/net/URL;->getPort()I

    move-result v0

    const/4 v2, -0x1

    if-ne v0, v2, :cond_1

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1}, Ljava/net/URL;->getProtocol()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, "://"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v1}, Ljava/net/URL;->getHost()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, ":443"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v1}, Ljava/net/URL;->getPath()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1}, Ljava/net/URL;->getQuery()Ljava/lang/String;

    move-result-object v2

    if-eqz v2, :cond_0

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, "?"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v1}, Ljava/net/URL;->getQuery()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    :try_end_0
    .catch Ljava/net/MalformedURLException; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v0

    :cond_0
    :goto_0
    return-object v0

    :catch_0
    move-exception v0

    invoke-virtual {v0}, Ljava/net/MalformedURLException;->printStackTrace()V

    :cond_1
    move-object v0, p1

    goto :goto_0
.end method

.method public b(Ljava/lang/String;Ljava/util/HashMap;)Ljava/lang/String;
    .locals 12
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "Ljava/util/HashMap",
            "<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;)",
            "Ljava/lang/String;"
        }
    .end annotation

    const-string v0, ""

    iget-object v1, p0, Lcn/uc/a/a/a/a/b/b;->k:Landroid/content/Context;

    invoke-static {v1}, Lcn/uc/a/a/a/b/a;->j(Landroid/content/Context;)Z

    move-result v2

    if-nez v2, :cond_0

    const/4 v0, -0x1

    iput v0, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    const-string v0, ""

    :goto_0
    return-object v0

    :cond_0
    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V

    const/4 v3, 0x0

    const/4 v2, 0x0

    invoke-virtual {p0, p1, p2}, Lcn/uc/a/a/a/a/b/b;->c(Ljava/lang/String;Ljava/util/HashMap;)Ljava/lang/String;

    move-result-object v5

    const-string v8, ""

    const-string v4, "HttpConnection"

    const-string v6, "getBodyStrWithRedirect"

    invoke-static {v4, v6, v5}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v4, "Http Request Get UrlAddr:"

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v4, "\n"

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    const/4 v7, 0x0

    :try_start_0
    iget-object v0, p0, Lcn/uc/a/a/a/a/b/b;->i:Ljava/lang/String;

    invoke-static {v1, v0}, Lcn/uc/a/a/a/a/b/b;->a(Landroid/content/Context;Ljava/lang/String;)Lorg/apache/http/impl/client/DefaultHttpClient;
    :try_end_0
    .catch Lorg/apache/http/client/ClientProtocolException; {:try_start_0 .. :try_end_0} :catch_14
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_11
    .catch Ljava/lang/IllegalStateException; {:try_start_0 .. :try_end_0} :catch_6
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_8
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    move-result-object v0

    :try_start_1
    invoke-interface {v0}, Lorg/apache/http/client/HttpClient;->getParams()Lorg/apache/http/params/HttpParams;

    move-result-object v1

    const/4 v4, 0x0

    invoke-static {v1, v4}, Lorg/apache/http/client/params/HttpClientParams;->setRedirecting(Lorg/apache/http/params/HttpParams;Z)V

    iget-object v4, p0, Lcn/uc/a/a/a/a/b/b;->j:Lorg/apache/http/HttpHost;

    if-eqz v4, :cond_3

    const-string v4, "http.route.default-proxy"

    iget-object v7, p0, Lcn/uc/a/a/a/a/b/b;->j:Lorg/apache/http/HttpHost;

    invoke-interface {v1, v4, v7}, Lorg/apache/http/params/HttpParams;->setParameter(Ljava/lang/String;Ljava/lang/Object;)Lorg/apache/http/params/HttpParams;

    const-string v4, "HttpConnection"

    const-string v7, "getBodyStrWithRedirect"

    new-instance v9, Ljava/lang/StringBuilder;

    invoke-direct {v9}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v10, p0, Lcn/uc/a/a/a/a/b/b;->j:Lorg/apache/http/HttpHost;

    invoke-virtual {v10}, Lorg/apache/http/HttpHost;->getHostName()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    const-string v10, ","

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    iget-object v10, p0, Lcn/uc/a/a/a/a/b/b;->j:Lorg/apache/http/HttpHost;

    invoke-virtual {v10}, Lorg/apache/http/HttpHost;->getPort()I

    move-result v10

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v9

    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v9

    invoke-static {v4, v7, v9}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :goto_1
    iget-object v4, p0, Lcn/uc/a/a/a/a/b/b;->i:Ljava/lang/String;

    invoke-virtual {v4}, Ljava/lang/String;->length()I

    move-result v4

    if-lez v4, :cond_4

    const-string v4, "http.useragent"

    iget-object v7, p0, Lcn/uc/a/a/a/a/b/b;->i:Ljava/lang/String;

    invoke-interface {v1, v4, v7}, Lorg/apache/http/params/HttpParams;->setParameter(Ljava/lang/String;Ljava/lang/Object;)Lorg/apache/http/params/HttpParams;

    const-string v1, "HttpConnection"

    const-string v4, "getBodyStrWithRedirect"

    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    const-string v9, "User-agent :"

    invoke-virtual {v7, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    iget-object v9, p0, Lcn/uc/a/a/a/a/b/b;->i:Ljava/lang/String;

    invoke-virtual {v7, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-static {v1, v4, v7}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :goto_2
    new-instance v1, Lorg/apache/http/client/methods/HttpGet;

    invoke-direct {v1, v5}, Lorg/apache/http/client/methods/HttpGet;-><init>(Ljava/lang/String;)V

    const-string v4, "Accept"

    const-string v7, "*/*"

    invoke-virtual {v1, v4, v7}, Lorg/apache/http/client/methods/HttpGet;->addHeader(Ljava/lang/String;Ljava/lang/String;)V

    const-string v4, "Accept-Encoding"

    const-string v7, "application/x-www-form-urlencoded"

    invoke-virtual {v1, v4, v7}, Lorg/apache/http/client/methods/HttpGet;->setHeader(Ljava/lang/String;Ljava/lang/String;)V

    iget-object v4, p0, Lcn/uc/a/a/a/a/b/b;->u:Lorg/apache/http/client/HttpClient;

    invoke-interface {v4, v1}, Lorg/apache/http/client/HttpClient;->execute(Lorg/apache/http/client/methods/HttpUriRequest;)Lorg/apache/http/HttpResponse;
    :try_end_1
    .catch Lorg/apache/http/client/ClientProtocolException; {:try_start_1 .. :try_end_1} :catch_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_2
    .catch Ljava/lang/IllegalStateException; {:try_start_1 .. :try_end_1} :catch_e
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_b
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    move-result-object v2

    :try_start_2
    const-string v1, "HttpConnection"

    const-string v4, "getBodyStrWithRedirect"

    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    const-string v9, "getStatusLine = "

    invoke-virtual {v7, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    invoke-interface {v2}, Lorg/apache/http/HttpResponse;->getStatusLine()Lorg/apache/http/StatusLine;

    move-result-object v9

    invoke-virtual {v9}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v7, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-static {v1, v4, v7}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    invoke-interface {v2}, Lorg/apache/http/HttpResponse;->getEntity()Lorg/apache/http/HttpEntity;

    move-result-object v1

    new-instance v4, Ljava/io/BufferedReader;

    new-instance v7, Ljava/io/InputStreamReader;

    invoke-interface {v1}, Lorg/apache/http/HttpEntity;->getContent()Ljava/io/InputStream;

    move-result-object v1

    invoke-direct {v7, v1}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;)V

    const/16 v1, 0x400

    invoke-direct {v4, v7, v1}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;I)V
    :try_end_2
    .catch Lorg/apache/http/client/ClientProtocolException; {:try_start_2 .. :try_end_2} :catch_15
    .catch Ljava/io/IOException; {:try_start_2 .. :try_end_2} :catch_12
    .catch Ljava/lang/IllegalStateException; {:try_start_2 .. :try_end_2} :catch_f
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_c
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    :goto_3
    :try_start_3
    invoke-virtual {v4}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_5

    invoke-virtual {v11, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\r\n"

    invoke-virtual {v11, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :try_end_3
    .catch Lorg/apache/http/client/ClientProtocolException; {:try_start_3 .. :try_end_3} :catch_0
    .catch Ljava/io/IOException; {:try_start_3 .. :try_end_3} :catch_13
    .catch Ljava/lang/IllegalStateException; {:try_start_3 .. :try_end_3} :catch_10
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_d
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    goto :goto_3

    :catch_0
    move-exception v1

    move-object v3, v1

    move-object v7, v0

    move-object v9, v2

    move-object v10, v4

    :goto_4
    :try_start_4
    const-string v0, "HttpConnection"

    const-string v1, "getBodyStrWithRedirect"

    const-string v2, "network"

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v3}, Lorg/apache/http/client/ClientProtocolException;->toString()Ljava/lang/String;

    move-result-object v3

    const-string v5, "\n|\r"

    invoke-virtual {v3, v5}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v3

    const/4 v5, 0x0

    aget-object v3, v3, v5

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    const/4 v4, 0x0

    const/4 v5, 0x2

    const-string v6, "key_mve"

    invoke-static {v6}, Lcn/uc/a/a/a/a;->c(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    invoke-static/range {v0 .. v6}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;ILjava/lang/String;)V
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_2

    if-eqz v9, :cond_7

    invoke-interface {v9}, Lorg/apache/http/HttpResponse;->getStatusLine()Lorg/apache/http/StatusLine;

    move-result-object v0

    invoke-interface {v0}, Lorg/apache/http/StatusLine;->getStatusCode()I

    move-result v0

    iput v0, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iget v0, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iput v0, p0, Lcn/uc/a/a/a/a/b/b;->s:I

    :goto_5
    if-eqz v10, :cond_f

    :try_start_5
    invoke-virtual {v10}, Ljava/io/BufferedReader;->close()V
    :try_end_5
    .catch Ljava/io/IOException; {:try_start_5 .. :try_end_5} :catch_4

    move-object v0, v7

    move-object v1, v8

    move-object v2, v9

    :cond_1
    :goto_6
    const-string v3, "HttpConnection"

    const-string v4, "getBodyStrWithRedirect"

    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v3, v4, v5}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    iget v3, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    packed-switch v3, :pswitch_data_0

    :pswitch_0
    if-eqz v0, :cond_2

    invoke-interface {v0}, Lorg/apache/http/client/HttpClient;->getConnectionManager()Lorg/apache/http/conn/ClientConnectionManager;

    move-result-object v0

    invoke-interface {v0}, Lorg/apache/http/conn/ClientConnectionManager;->shutdown()V

    :cond_2
    if-eqz v1, :cond_e

    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v0

    if-lez v0, :cond_e

    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    invoke-virtual {p0, v1, v0}, Lcn/uc/a/a/a/a/b/b;->b(Ljava/lang/String;Ljava/util/HashMap;)Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_0

    :cond_3
    :try_start_6
    const-string v4, "HttpConnection"

    const-string v7, "getBodyStrWithRedirect"

    const-string v9, "proxy is null"

    invoke-static {v4, v7, v9}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    goto/16 :goto_1

    :catch_1
    move-exception v1

    move-object v7, v0

    move-object v9, v2

    move-object v10, v3

    move-object v3, v1

    goto/16 :goto_4

    :cond_4
    const-string v1, "HttpConnection"

    const-string v4, "getBodyStrWithRedirect"

    const-string v7, "User-agent null"

    invoke-static {v1, v4, v7}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_6
    .catch Lorg/apache/http/client/ClientProtocolException; {:try_start_6 .. :try_end_6} :catch_1
    .catch Ljava/io/IOException; {:try_start_6 .. :try_end_6} :catch_2
    .catch Ljava/lang/IllegalStateException; {:try_start_6 .. :try_end_6} :catch_e
    .catch Ljava/lang/Exception; {:try_start_6 .. :try_end_6} :catch_b
    .catchall {:try_start_6 .. :try_end_6} :catchall_0

    goto/16 :goto_2

    :catch_2
    move-exception v1

    move-object v7, v0

    move-object v9, v2

    move-object v10, v3

    move-object v3, v1

    :goto_7
    :try_start_7
    const-string v0, "HttpConnection"

    const-string v1, "getBodyStrWithRedirect"

    const-string v2, "io"

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v3}, Ljava/io/IOException;->toString()Ljava/lang/String;

    move-result-object v3

    const-string v5, "\n|\r"

    invoke-virtual {v3, v5}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v3

    const/4 v5, 0x0

    aget-object v3, v3, v5

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    const/4 v4, 0x0

    const/16 v5, 0x3f

    const-string v6, "key_mve"

    invoke-static {v6}, Lcn/uc/a/a/a/a;->c(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    invoke-static/range {v0 .. v6}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;ILjava/lang/String;)V
    :try_end_7
    .catchall {:try_start_7 .. :try_end_7} :catchall_2

    if-eqz v9, :cond_8

    invoke-interface {v9}, Lorg/apache/http/HttpResponse;->getStatusLine()Lorg/apache/http/StatusLine;

    move-result-object v0

    invoke-interface {v0}, Lorg/apache/http/StatusLine;->getStatusCode()I

    move-result v0

    iput v0, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iget v0, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iput v0, p0, Lcn/uc/a/a/a/a/b/b;->s:I

    :goto_8
    if-eqz v10, :cond_f

    :try_start_8
    invoke-virtual {v10}, Ljava/io/BufferedReader;->close()V
    :try_end_8
    .catch Ljava/io/IOException; {:try_start_8 .. :try_end_8} :catch_5

    move-object v0, v7

    move-object v1, v8

    move-object v2, v9

    goto/16 :goto_6

    :cond_5
    :try_start_9
    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1, v2, v5}, Lcn/uc/a/a/a/a/b/c;->a(Ljava/lang/String;Lorg/apache/http/HttpResponse;Ljava/lang/String;)Ljava/lang/String;
    :try_end_9
    .catch Lorg/apache/http/client/ClientProtocolException; {:try_start_9 .. :try_end_9} :catch_0
    .catch Ljava/io/IOException; {:try_start_9 .. :try_end_9} :catch_13
    .catch Ljava/lang/IllegalStateException; {:try_start_9 .. :try_end_9} :catch_10
    .catch Ljava/lang/Exception; {:try_start_9 .. :try_end_9} :catch_d
    .catchall {:try_start_9 .. :try_end_9} :catchall_1

    move-result-object v1

    if-eqz v2, :cond_6

    invoke-interface {v2}, Lorg/apache/http/HttpResponse;->getStatusLine()Lorg/apache/http/StatusLine;

    move-result-object v3

    invoke-interface {v3}, Lorg/apache/http/StatusLine;->getStatusCode()I

    move-result v3

    iput v3, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iget v3, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iput v3, p0, Lcn/uc/a/a/a/a/b/b;->s:I

    :goto_9
    if-eqz v4, :cond_1

    :try_start_a
    invoke-virtual {v4}, Ljava/io/BufferedReader;->close()V
    :try_end_a
    .catch Ljava/io/IOException; {:try_start_a .. :try_end_a} :catch_3

    goto/16 :goto_6

    :catch_3
    move-exception v3

    invoke-virtual {v3}, Ljava/io/IOException;->printStackTrace()V

    goto/16 :goto_6

    :cond_6
    const/4 v3, -0x2

    iput v3, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    goto :goto_9

    :cond_7
    const/4 v0, -0x2

    iput v0, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    goto/16 :goto_5

    :catch_4
    move-exception v0

    invoke-virtual {v0}, Ljava/io/IOException;->printStackTrace()V

    move-object v0, v7

    move-object v1, v8

    move-object v2, v9

    goto/16 :goto_6

    :cond_8
    const/4 v0, -0x2

    iput v0, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    goto :goto_8

    :catch_5
    move-exception v0

    invoke-virtual {v0}, Ljava/io/IOException;->printStackTrace()V

    move-object v0, v7

    move-object v1, v8

    move-object v2, v9

    goto/16 :goto_6

    :catch_6
    move-exception v0

    move-object v9, v2

    move-object v10, v3

    move-object v3, v0

    :goto_a
    :try_start_b
    const-string v0, "HttpConnection"

    const-string v1, "getBodyStrWithRedirect"

    const-string v2, "network"

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v3}, Ljava/lang/IllegalStateException;->toString()Ljava/lang/String;

    move-result-object v3

    const-string v5, "\n|\r"

    invoke-virtual {v3, v5}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v3

    const/4 v5, 0x0

    aget-object v3, v3, v5

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    const/4 v4, 0x0

    const/4 v5, 0x2

    const-string v6, "key_mve"

    invoke-static {v6}, Lcn/uc/a/a/a/a;->c(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    invoke-static/range {v0 .. v6}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;ILjava/lang/String;)V
    :try_end_b
    .catchall {:try_start_b .. :try_end_b} :catchall_2

    if-eqz v9, :cond_9

    invoke-interface {v9}, Lorg/apache/http/HttpResponse;->getStatusLine()Lorg/apache/http/StatusLine;

    move-result-object v0

    invoke-interface {v0}, Lorg/apache/http/StatusLine;->getStatusCode()I

    move-result v0

    iput v0, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iget v0, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iput v0, p0, Lcn/uc/a/a/a/a/b/b;->s:I

    :goto_b
    if-eqz v10, :cond_f

    :try_start_c
    invoke-virtual {v10}, Ljava/io/BufferedReader;->close()V
    :try_end_c
    .catch Ljava/io/IOException; {:try_start_c .. :try_end_c} :catch_7

    move-object v0, v7

    move-object v1, v8

    move-object v2, v9

    goto/16 :goto_6

    :cond_9
    const/4 v0, -0x2

    iput v0, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    goto :goto_b

    :catch_7
    move-exception v0

    invoke-virtual {v0}, Ljava/io/IOException;->printStackTrace()V

    move-object v0, v7

    move-object v1, v8

    move-object v2, v9

    goto/16 :goto_6

    :catch_8
    move-exception v0

    move-object v9, v2

    move-object v10, v3

    move-object v3, v0

    :goto_c
    :try_start_d
    const-string v0, "HttpConnection"

    const-string v1, "getBodyStrWithRedirect"

    const-string v2, "network"

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v3}, Ljava/lang/Exception;->toString()Ljava/lang/String;

    move-result-object v3

    const-string v5, "\n|\r"

    invoke-virtual {v3, v5}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v3

    const/4 v5, 0x0

    aget-object v3, v3, v5

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    const/4 v4, 0x0

    const/4 v5, 0x2

    const-string v6, "key_mve"

    invoke-static {v6}, Lcn/uc/a/a/a/a;->c(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    invoke-static/range {v0 .. v6}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;ILjava/lang/String;)V
    :try_end_d
    .catchall {:try_start_d .. :try_end_d} :catchall_2

    if-eqz v9, :cond_a

    invoke-interface {v9}, Lorg/apache/http/HttpResponse;->getStatusLine()Lorg/apache/http/StatusLine;

    move-result-object v0

    invoke-interface {v0}, Lorg/apache/http/StatusLine;->getStatusCode()I

    move-result v0

    iput v0, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iget v0, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iput v0, p0, Lcn/uc/a/a/a/a/b/b;->s:I

    :goto_d
    if-eqz v10, :cond_f

    :try_start_e
    invoke-virtual {v10}, Ljava/io/BufferedReader;->close()V
    :try_end_e
    .catch Ljava/io/IOException; {:try_start_e .. :try_end_e} :catch_9

    move-object v0, v7

    move-object v1, v8

    move-object v2, v9

    goto/16 :goto_6

    :cond_a
    const/4 v0, -0x2

    iput v0, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    goto :goto_d

    :catch_9
    move-exception v0

    invoke-virtual {v0}, Ljava/io/IOException;->printStackTrace()V

    move-object v0, v7

    move-object v1, v8

    move-object v2, v9

    goto/16 :goto_6

    :catchall_0
    move-exception v0

    :goto_e
    if-eqz v2, :cond_c

    invoke-interface {v2}, Lorg/apache/http/HttpResponse;->getStatusLine()Lorg/apache/http/StatusLine;

    move-result-object v1

    invoke-interface {v1}, Lorg/apache/http/StatusLine;->getStatusCode()I

    move-result v1

    iput v1, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iget v1, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    iput v1, p0, Lcn/uc/a/a/a/a/b/b;->s:I

    :goto_f
    if-eqz v3, :cond_b

    :try_start_f
    invoke-virtual {v3}, Ljava/io/BufferedReader;->close()V
    :try_end_f
    .catch Ljava/io/IOException; {:try_start_f .. :try_end_f} :catch_a

    :cond_b
    :goto_10
    throw v0

    :cond_c
    const/4 v1, -0x2

    iput v1, p0, Lcn/uc/a/a/a/a/b/b;->l:I

    goto :goto_f

    :catch_a
    move-exception v1

    invoke-virtual {v1}, Ljava/io/IOException;->printStackTrace()V

    goto :goto_10

    :pswitch_1
    const-string v0, "location"

    invoke-interface {v2, v0}, Lorg/apache/http/HttpResponse;->getHeaders(Ljava/lang/String;)[Lorg/apache/http/Header;

    move-result-object v1

    array-length v2, v1

    const/4 v0, 0x0

    :goto_11
    if-ge v0, v2, :cond_d

    aget-object v3, v1, v0

    invoke-interface {v3}, Lorg/apache/http/Header;->getValue()Ljava/lang/String;

    move-result-object v3

    iput-object v3, p0, Lcn/uc/a/a/a/a/b/b;->r:Ljava/lang/String;

    const-string v3, "HttpConnection"

    const-string v4, "getBodyStrWithRedirect"

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "redirectUrl = "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    iget-object v6, p0, Lcn/uc/a/a/a/a/b/b;->r:Ljava/lang/String;

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v3, v4, v5}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    add-int/lit8 v0, v0, 0x1

    goto :goto_11

    :cond_d
    iget-object v0, p0, Lcn/uc/a/a/a/a/b/b;->r:Ljava/lang/String;

    new-instance v1, Ljava/util/HashMap;

    invoke-direct {v1}, Ljava/util/HashMap;-><init>()V

    invoke-virtual {p0, v0, v1}, Lcn/uc/a/a/a/a/b/b;->b(Ljava/lang/String;Ljava/util/HashMap;)Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_0

    :cond_e
    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_0

    :catchall_1
    move-exception v0

    move-object v3, v4

    goto :goto_e

    :catchall_2
    move-exception v0

    move-object v2, v9

    move-object v3, v10

    goto :goto_e

    :catch_b
    move-exception v1

    move-object v7, v0

    move-object v9, v2

    move-object v10, v3

    move-object v3, v1

    goto/16 :goto_c

    :catch_c
    move-exception v1

    move-object v7, v0

    move-object v9, v2

    move-object v10, v3

    move-object v3, v1

    goto/16 :goto_c

    :catch_d
    move-exception v1

    move-object v3, v1

    move-object v7, v0

    move-object v9, v2

    move-object v10, v4

    goto/16 :goto_c

    :catch_e
    move-exception v1

    move-object v7, v0

    move-object v9, v2

    move-object v10, v3

    move-object v3, v1

    goto/16 :goto_a

    :catch_f
    move-exception v1

    move-object v7, v0

    move-object v9, v2

    move-object v10, v3

    move-object v3, v1

    goto/16 :goto_a

    :catch_10
    move-exception v1

    move-object v3, v1

    move-object v7, v0

    move-object v9, v2

    move-object v10, v4

    goto/16 :goto_a

    :catch_11
    move-exception v0

    move-object v9, v2

    move-object v10, v3

    move-object v3, v0

    goto/16 :goto_7

    :catch_12
    move-exception v1

    move-object v7, v0

    move-object v9, v2

    move-object v10, v3

    move-object v3, v1

    goto/16 :goto_7

    :catch_13
    move-exception v1

    move-object v3, v1

    move-object v7, v0

    move-object v9, v2

    move-object v10, v4

    goto/16 :goto_7

    :catch_14
    move-exception v0

    move-object v9, v2

    move-object v10, v3

    move-object v3, v0

    goto/16 :goto_4

    :catch_15
    move-exception v1

    move-object v7, v0

    move-object v9, v2

    move-object v10, v3

    move-object v3, v1

    goto/16 :goto_4

    :cond_f
    move-object v0, v7

    move-object v1, v8

    move-object v2, v9

    goto/16 :goto_6

    nop

    :pswitch_data_0
    .packed-switch 0x12d
        :pswitch_1
        :pswitch_1
        :pswitch_1
        :pswitch_0
        :pswitch_0
        :pswitch_0
        :pswitch_1
    .end packed-switch
.end method

.method public c(Ljava/lang/String;Ljava/util/HashMap;)Ljava/lang/String;
    .locals 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "Ljava/util/HashMap",
            "<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;)",
            "Ljava/lang/String;"
        }
    .end annotation

    invoke-virtual {p0, p1}, Lcn/uc/a/a/a/a/b/b;->b(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    new-instance v3, Ljava/lang/StringBuilder;

    const-string v0, ""

    invoke-direct {v3, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    if-eqz p2, :cond_3

    invoke-virtual {p2}, Ljava/util/HashMap;->size()I

    move-result v0

    if-lez v0, :cond_3

    invoke-virtual {p2}, Ljava/util/HashMap;->entrySet()Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v4

    :goto_0
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/Map$Entry;

    :try_start_0
    invoke-interface {v0}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "="

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-interface {v0}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    invoke-interface {v0}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v0

    if-nez v0, :cond_0

    const-string v1, ""

    :cond_0
    const-string v0, "UTF-8"

    invoke-static {v1, v0}, Ljava/net/URLEncoder;->encode(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "&"

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :try_end_0
    .catch Ljava/io/UnsupportedEncodingException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_1

    goto :goto_0

    :catch_0
    move-exception v0

    const-string v1, "HttpConnection"

    const-string v5, "encodeUrlWithParams"

    const-string v6, ""

    invoke-static {v1, v5, v6, v0}, Lcn/uc/a/a/a/i;->b(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;)V

    goto :goto_0

    :catch_1
    move-exception v0

    const-string v1, "HttpConnection"

    const-string v5, "encodeUrlWithParams"

    const-string v6, ""

    invoke-static {v1, v5, v6, v0}, Lcn/uc/a/a/a/i;->b(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;)V

    goto :goto_0

    :cond_1
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v1

    if-lez v1, :cond_2

    const/4 v1, 0x0

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->length()I

    move-result v3

    add-int/lit8 v3, v3, -0x1

    invoke-virtual {v0, v1, v3}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0

    :cond_2
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "?"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :goto_1
    return-object v0

    :cond_3
    move-object v0, v2

    goto :goto_1
.end method

.method public c()Z
    .locals 1

    iget-object v0, p0, Lcn/uc/a/a/a/a/b/b;->r:Ljava/lang/String;

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    :goto_0
    return v0

    :cond_0
    const/4 v0, 0x0

    goto :goto_0
.end method

.method public d()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcn/uc/a/a/a/a/b/b;->r:Ljava/lang/String;

    return-object v0
.end method

.method public e()Z
    .locals 2

    iget-object v0, p0, Lcn/uc/a/a/a/a/b/b;->k:Landroid/content/Context;

    const-string v1, "connectivity"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/net/ConnectivityManager;

    invoke-virtual {v0}, Landroid/net/ConnectivityManager;->getActiveNetworkInfo()Landroid/net/NetworkInfo;

    move-result-object v0

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Landroid/net/NetworkInfo;->getState()Landroid/net/NetworkInfo$State;

    move-result-object v0

    sget-object v1, Landroid/net/NetworkInfo$State;->CONNECTED:Landroid/net/NetworkInfo$State;

    if-ne v0, v1, :cond_0

    const/4 v0, 0x1

    :goto_0
    return v0

    :cond_0
    const/4 v0, 0x0

    goto :goto_0
.end method

.method protected f()Lorg/apache/http/impl/client/DefaultHttpClient;
    .locals 2

    iget-object v0, p0, Lcn/uc/a/a/a/a/b/b;->k:Landroid/content/Context;

    iget-object v1, p0, Lcn/uc/a/a/a/a/b/b;->i:Ljava/lang/String;

    invoke-static {v0, v1}, Lcn/uc/a/a/a/a/b/b;->a(Landroid/content/Context;Ljava/lang/String;)Lorg/apache/http/impl/client/DefaultHttpClient;

    move-result-object v0

    return-object v0
.end method

.method public g()V
    .locals 1

    const/4 v0, 0x1

    iput-boolean v0, p0, Lcn/uc/a/a/a/a/b/b;->v:Z

    iget-object v0, p0, Lcn/uc/a/a/a/a/b/b;->t:Ljava/net/HttpURLConnection;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcn/uc/a/a/a/a/b/b;->t:Ljava/net/HttpURLConnection;

    invoke-virtual {v0}, Ljava/net/HttpURLConnection;->disconnect()V

    :cond_0
    iget-object v0, p0, Lcn/uc/a/a/a/a/b/b;->u:Lorg/apache/http/client/HttpClient;

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcn/uc/a/a/a/a/b/b;->u:Lorg/apache/http/client/HttpClient;

    invoke-interface {v0}, Lorg/apache/http/client/HttpClient;->getConnectionManager()Lorg/apache/http/conn/ClientConnectionManager;

    move-result-object v0

    invoke-interface {v0}, Lorg/apache/http/conn/ClientConnectionManager;->shutdown()V

    :cond_1
    return-void
.end method
