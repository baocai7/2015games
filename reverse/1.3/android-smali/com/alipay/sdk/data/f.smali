.class public final Lcom/alipay/sdk/data/f;
.super Ljava/lang/Object;
.source "SourceFile"


# static fields
.field public static final a:I = 0x3e8

.field public static final b:I = 0x1f7


# instance fields
.field public c:I

.field public d:Ljava/lang/String;

.field public e:J

.field public f:Ljava/lang/String;

.field public g:Ljava/lang/String;

.field public h:Ljava/lang/String;

.field public i:Lorg/json/JSONObject;

.field public j:Ljava/lang/String;

.field public k:Z

.field public l:Lcom/alipay/sdk/data/a;

.field m:[Lorg/apache/http/Header;


# direct methods
.method public constructor <init>()V
    .locals 3

    .prologue
    const/4 v2, 0x0

    .line 14
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 20
    const/4 v0, 0x0

    iput v0, p0, Lcom/alipay/sdk/data/f;->c:I

    .line 21
    const-string v0, ""

    iput-object v0, p0, Lcom/alipay/sdk/data/f;->d:Ljava/lang/String;

    .line 22
    const-wide/16 v0, 0x0

    iput-wide v0, p0, Lcom/alipay/sdk/data/f;->e:J

    .line 23
    const-string v0, ""

    iput-object v0, p0, Lcom/alipay/sdk/data/f;->f:Ljava/lang/String;

    .line 24
    iput-object v2, p0, Lcom/alipay/sdk/data/f;->g:Ljava/lang/String;

    .line 25
    iput-object v2, p0, Lcom/alipay/sdk/data/f;->h:Ljava/lang/String;

    .line 27
    iput-object v2, p0, Lcom/alipay/sdk/data/f;->i:Lorg/json/JSONObject;

    .line 31
    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/alipay/sdk/data/f;->k:Z

    .line 36
    iput-object v2, p0, Lcom/alipay/sdk/data/f;->l:Lcom/alipay/sdk/data/a;

    .line 41
    iput-object v2, p0, Lcom/alipay/sdk/data/f;->m:[Lorg/apache/http/Header;

    return-void
.end method

.method private a()Lcom/alipay/sdk/data/a;
    .locals 1

    .prologue
    .line 48
    iget-object v0, p0, Lcom/alipay/sdk/data/f;->l:Lcom/alipay/sdk/data/a;

    return-object v0
.end method

.method private a(I)V
    .locals 0

    .prologue
    .line 60
    iput p1, p0, Lcom/alipay/sdk/data/f;->c:I

    .line 61
    return-void
.end method

.method private a(J)V
    .locals 1

    .prologue
    .line 84
    iput-wide p1, p0, Lcom/alipay/sdk/data/f;->e:J

    .line 85
    return-void
.end method

.method private a(Lcom/alipay/sdk/data/a;)V
    .locals 0

    .prologue
    .line 96
    iput-object p1, p0, Lcom/alipay/sdk/data/f;->l:Lcom/alipay/sdk/data/a;

    .line 97
    return-void
.end method

.method private a(Ljava/lang/String;)V
    .locals 0

    .prologue
    .line 64
    iput-object p1, p0, Lcom/alipay/sdk/data/f;->d:Ljava/lang/String;

    .line 65
    return-void
.end method

.method private a(Lorg/json/JSONObject;)V
    .locals 0

    .prologue
    .line 88
    iput-object p1, p0, Lcom/alipay/sdk/data/f;->i:Lorg/json/JSONObject;

    .line 89
    return-void
.end method

.method private b()V
    .locals 1

    .prologue
    .line 52
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/alipay/sdk/data/f;->k:Z

    .line 53
    return-void
.end method

.method private b(Ljava/lang/String;)V
    .locals 0

    .prologue
    .line 72
    iput-object p1, p0, Lcom/alipay/sdk/data/f;->f:Ljava/lang/String;

    .line 73
    return-void
.end method

.method private c()I
    .locals 1

    .prologue
    .line 56
    iget v0, p0, Lcom/alipay/sdk/data/f;->c:I

    return v0
.end method

.method private c(Ljava/lang/String;)V
    .locals 0

    .prologue
    .line 76
    iput-object p1, p0, Lcom/alipay/sdk/data/f;->g:Ljava/lang/String;

    .line 77
    return-void
.end method

.method private d()Ljava/lang/String;
    .locals 1

    .prologue
    .line 68
    iget-object v0, p0, Lcom/alipay/sdk/data/f;->f:Ljava/lang/String;

    return-object v0
.end method

.method private d(Ljava/lang/String;)V
    .locals 0

    .prologue
    .line 80
    iput-object p1, p0, Lcom/alipay/sdk/data/f;->h:Ljava/lang/String;

    .line 81
    return-void
.end method

.method private e(Ljava/lang/String;)V
    .locals 0

    .prologue
    .line 92
    iput-object p1, p0, Lcom/alipay/sdk/data/f;->j:Ljava/lang/String;

    .line 93
    return-void
.end method
