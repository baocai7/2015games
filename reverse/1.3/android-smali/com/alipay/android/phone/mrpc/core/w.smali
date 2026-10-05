.class public final Lcom/alipay/android/phone/mrpc/core/w;
.super Lcom/alipay/android/phone/mrpc/core/ab;


# instance fields
.field a:J

.field b:J

.field c:Ljava/lang/String;

.field d:Lcom/alipay/android/phone/mrpc/core/b;

.field private g:I

.field private h:Ljava/lang/String;


# direct methods
.method public constructor <init>(Lcom/alipay/android/phone/mrpc/core/b;ILjava/lang/String;[B)V
    .locals 0

    invoke-direct {p0}, Lcom/alipay/android/phone/mrpc/core/ab;-><init>()V

    iput-object p1, p0, Lcom/alipay/android/phone/mrpc/core/w;->d:Lcom/alipay/android/phone/mrpc/core/b;

    iput p2, p0, Lcom/alipay/android/phone/mrpc/core/w;->g:I

    iput-object p3, p0, Lcom/alipay/android/phone/mrpc/core/w;->h:Ljava/lang/String;

    iput-object p4, p0, Lcom/alipay/android/phone/mrpc/core/w;->e:[B

    return-void
.end method

.method private a(J)V
    .locals 1

    iput-wide p1, p0, Lcom/alipay/android/phone/mrpc/core/w;->a:J

    return-void
.end method

.method private b()Lcom/alipay/android/phone/mrpc/core/b;
    .locals 1

    iget-object v0, p0, Lcom/alipay/android/phone/mrpc/core/w;->d:Lcom/alipay/android/phone/mrpc/core/b;

    return-object v0
.end method

.method private b(J)V
    .locals 1

    iput-wide p1, p0, Lcom/alipay/android/phone/mrpc/core/w;->b:J

    return-void
.end method

.method private b(Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcom/alipay/android/phone/mrpc/core/w;->c:Ljava/lang/String;

    return-void
.end method
