.class public final Lcom/alipay/mobilesecuritysdk/datainfo/f;
.super Ljava/lang/Object;


# instance fields
.field public a:Ljava/lang/String;

.field public b:I

.field public c:Ljava/lang/String;

.field public d:Z

.field private e:Ljava/lang/String;


# direct methods
.method public constructor <init>()V
    .locals 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/alipay/mobilesecuritysdk/datainfo/f;->d:Z

    return-void
.end method

.method private a()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/datainfo/f;->e:Ljava/lang/String;

    return-object v0
.end method

.method private a(I)V
    .locals 0

    iput p1, p0, Lcom/alipay/mobilesecuritysdk/datainfo/f;->b:I

    return-void
.end method

.method private a(Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcom/alipay/mobilesecuritysdk/datainfo/f;->e:Ljava/lang/String;

    return-void
.end method

.method private a(Z)V
    .locals 0

    iput-boolean p1, p0, Lcom/alipay/mobilesecuritysdk/datainfo/f;->d:Z

    return-void
.end method

.method private b(Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcom/alipay/mobilesecuritysdk/datainfo/f;->a:Ljava/lang/String;

    return-void
.end method

.method private b()Z
    .locals 1

    iget-boolean v0, p0, Lcom/alipay/mobilesecuritysdk/datainfo/f;->d:Z

    return v0
.end method

.method private c()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/datainfo/f;->a:Ljava/lang/String;

    return-object v0
.end method

.method private c(Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcom/alipay/mobilesecuritysdk/datainfo/f;->c:Ljava/lang/String;

    return-void
.end method

.method private d()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/datainfo/f;->c:Ljava/lang/String;

    return-object v0
.end method

.method private e()I
    .locals 1

    iget v0, p0, Lcom/alipay/mobilesecuritysdk/datainfo/f;->b:I

    return v0
.end method

.method private f()Z
    .locals 1

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/datainfo/f;->a:Ljava/lang/String;

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_0

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/datainfo/f;->c:Ljava/lang/String;

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_1

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0

    :cond_1
    const/4 v0, 0x1

    goto :goto_0
.end method
