.class public final Lcom/alipay/mobilesecuritysdk/datainfo/c;
.super Ljava/lang/Object;


# instance fields
.field public a:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List",
            "<",
            "Lcom/alipay/mobilesecuritysdk/datainfo/f;",
            ">;"
        }
    .end annotation
.end field

.field public b:Ljava/lang/String;

.field public c:Ljava/lang/String;

.field public d:Ljava/lang/String;

.field public e:Ljava/lang/String;

.field public f:Ljava/lang/String;

.field public g:Ljava/lang/String;

.field public h:Ljava/lang/String;

.field public i:Ljava/lang/String;

.field private final j:I

.field private final k:D

.field private final l:D

.field private final m:D

.field private final n:D

.field private o:Ljava/util/List;
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
    .locals 2

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/16 v0, 0x3840

    iput v0, p0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->j:I

    const-wide v0, 0x4066800000000000L    # 180.0

    iput-wide v0, p0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->k:D

    const-wide v0, -0x3f99800000000000L    # -180.0

    iput-wide v0, p0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->l:D

    const-wide v0, 0x4056800000000000L    # 90.0

    iput-wide v0, p0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->m:D

    const-wide v0, -0x3fa9800000000000L    # -90.0

    iput-wide v0, p0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->n:D

    return-void
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

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->o:Ljava/util/List;

    return-object v0
.end method

.method private a(I)V
    .locals 4

    int-to-double v0, p1

    const-wide v2, 0x40cc200000000000L    # 14400.0

    div-double/2addr v0, v2

    invoke-virtual {p0, v0, v1}, Lcom/alipay/mobilesecuritysdk/datainfo/c;->a(D)V

    return-void
.end method

.method private a(Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->g:Ljava/lang/String;

    return-void
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

    iput-object p1, p0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->o:Ljava/util/List;

    return-void
.end method

.method private b()Ljava/util/List;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List",
            "<",
            "Lcom/alipay/mobilesecuritysdk/datainfo/f;",
            ">;"
        }
    .end annotation

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->a:Ljava/util/List;

    return-object v0
.end method

.method private b(I)V
    .locals 4

    int-to-double v0, p1

    const-wide v2, 0x40cc200000000000L    # 14400.0

    div-double/2addr v0, v2

    invoke-virtual {p0, v0, v1}, Lcom/alipay/mobilesecuritysdk/datainfo/c;->b(D)V

    return-void
.end method

.method private b(Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->h:Ljava/lang/String;

    return-void
.end method

.method private b(Ljava/util/List;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List",
            "<",
            "Lcom/alipay/mobilesecuritysdk/datainfo/f;",
            ">;)V"
        }
    .end annotation

    iput-object p1, p0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->a:Ljava/util/List;

    return-void
.end method

.method private c()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->g:Ljava/lang/String;

    return-object v0
.end method

.method private static c(D)Ljava/lang/String;
    .locals 3

    new-instance v0, Ljava/math/BigDecimal;

    invoke-direct {v0, p0, p1}, Ljava/math/BigDecimal;-><init>(D)V

    const/4 v1, 0x5

    const/4 v2, 0x4

    invoke-virtual {v0, v1, v2}, Ljava/math/BigDecimal;->setScale(II)Ljava/math/BigDecimal;

    move-result-object v0

    invoke-virtual {v0}, Ljava/math/BigDecimal;->doubleValue()D

    move-result-wide v0

    invoke-static {v0, v1}, Ljava/lang/String;->valueOf(D)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method private c(Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->i:Ljava/lang/String;

    return-void
.end method

.method private d()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->h:Ljava/lang/String;

    return-object v0
.end method

.method private d(Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->b:Ljava/lang/String;

    return-void
.end method

.method private e()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->i:Ljava/lang/String;

    return-object v0
.end method

.method private e(Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->c:Ljava/lang/String;

    return-void
.end method

.method private f(Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->d:Ljava/lang/String;

    return-void
.end method

.method private f()Z
    .locals 1

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->d:Ljava/lang/String;

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_0

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->c:Ljava/lang/String;

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_2

    :cond_0
    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->e:Ljava/lang/String;

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_1

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->f:Ljava/lang/String;

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_2

    :cond_1
    const/4 v0, 0x0

    :goto_0
    return v0

    :cond_2
    const/4 v0, 0x1

    goto :goto_0
.end method

.method private g()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->b:Ljava/lang/String;

    return-object v0
.end method

.method private g(Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->e:Ljava/lang/String;

    return-void
.end method

.method private h()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->c:Ljava/lang/String;

    return-object v0
.end method

.method private h(Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->f:Ljava/lang/String;

    return-void
.end method

.method private i()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->d:Ljava/lang/String;

    return-object v0
.end method

.method private j()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->e:Ljava/lang/String;

    return-object v0
.end method

.method private k()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->f:Ljava/lang/String;

    return-object v0
.end method


# virtual methods
.method public final a(D)V
    .locals 2

    const-wide v0, 0x4066800000000000L    # 180.0

    cmpg-double v0, p1, v0

    if-gez v0, :cond_0

    const-wide v0, -0x3f99800000000000L    # -180.0

    cmpl-double v0, p1, v0

    if-lez v0, :cond_0

    invoke-static {p1, p2}, Lcom/alipay/mobilesecuritysdk/datainfo/c;->c(D)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->c:Ljava/lang/String;

    :cond_0
    return-void
.end method

.method public final b(D)V
    .locals 2

    const-wide v0, 0x4056800000000000L    # 90.0

    cmpg-double v0, p1, v0

    if-gez v0, :cond_0

    const-wide v0, -0x3fa9800000000000L    # -90.0

    cmpl-double v0, p1, v0

    if-lez v0, :cond_0

    invoke-static {p1, p2}, Lcom/alipay/mobilesecuritysdk/datainfo/c;->c(D)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/alipay/mobilesecuritysdk/datainfo/c;->d:Ljava/lang/String;

    :cond_0
    return-void
.end method
