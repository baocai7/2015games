.class public Lcom/alipay/sdk/protocol/c;
.super Ljava/lang/Object;
.source "SourceFile"


# instance fields
.field public a:Lcom/alipay/sdk/data/e;

.field public b:Lcom/alipay/sdk/data/f;

.field public c:Lorg/json/JSONObject;


# direct methods
.method public constructor <init>(Lcom/alipay/sdk/data/e;Lcom/alipay/sdk/data/f;)V
    .locals 0

    .prologue
    .line 21
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 22
    iput-object p1, p0, Lcom/alipay/sdk/protocol/c;->a:Lcom/alipay/sdk/data/e;

    .line 23
    iput-object p2, p0, Lcom/alipay/sdk/protocol/c;->b:Lcom/alipay/sdk/data/f;

    .line 24
    return-void
.end method

.method private a()Lcom/alipay/sdk/data/e;
    .locals 1

    .prologue
    .line 27
    iget-object v0, p0, Lcom/alipay/sdk/protocol/c;->a:Lcom/alipay/sdk/data/e;

    return-object v0
.end method

.method private b()Lcom/alipay/sdk/data/f;
    .locals 1

    .prologue
    .line 31
    iget-object v0, p0, Lcom/alipay/sdk/protocol/c;->b:Lcom/alipay/sdk/data/f;

    return-object v0
.end method

.method private c()Lorg/json/JSONObject;
    .locals 1

    .prologue
    .line 38
    iget-object v0, p0, Lcom/alipay/sdk/protocol/c;->c:Lorg/json/JSONObject;

    return-object v0
.end method


# virtual methods
.method public a(Lorg/json/JSONObject;)V
    .locals 0

    .prologue
    .line 42
    iput-object p1, p0, Lcom/alipay/sdk/protocol/c;->c:Lorg/json/JSONObject;

    .line 43
    return-void
.end method
