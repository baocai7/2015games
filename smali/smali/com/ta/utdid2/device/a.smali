.class public final Lcom/ta/utdid2/device/a;
.super Ljava/lang/Object;


# instance fields
.field a:Ljava/lang/String;

.field b:Ljava/lang/String;

.field c:Ljava/lang/String;

.field d:Ljava/lang/String;

.field e:J

.field f:J


# direct methods
.method public constructor <init>()V
    .locals 3

    const-wide/16 v1, 0x0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const-string v0, ""

    iput-object v0, p0, Lcom/ta/utdid2/device/a;->a:Ljava/lang/String;

    const-string v0, ""

    iput-object v0, p0, Lcom/ta/utdid2/device/a;->b:Ljava/lang/String;

    const-string v0, ""

    iput-object v0, p0, Lcom/ta/utdid2/device/a;->c:Ljava/lang/String;

    const-string v0, ""

    iput-object v0, p0, Lcom/ta/utdid2/device/a;->d:Ljava/lang/String;

    iput-wide v1, p0, Lcom/ta/utdid2/device/a;->e:J

    iput-wide v1, p0, Lcom/ta/utdid2/device/a;->f:J

    return-void
.end method

.method private a()J
    .locals 2

    iget-wide v0, p0, Lcom/ta/utdid2/device/a;->f:J

    return-wide v0
.end method

.method private a(J)V
    .locals 0

    iput-wide p1, p0, Lcom/ta/utdid2/device/a;->f:J

    return-void
.end method

.method private a(Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcom/ta/utdid2/device/a;->a:Ljava/lang/String;

    return-void
.end method

.method private b()J
    .locals 2

    iget-wide v0, p0, Lcom/ta/utdid2/device/a;->e:J

    return-wide v0
.end method

.method private b(J)V
    .locals 0

    iput-wide p1, p0, Lcom/ta/utdid2/device/a;->e:J

    return-void
.end method

.method private b(Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcom/ta/utdid2/device/a;->b:Ljava/lang/String;

    return-void
.end method

.method private c()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcom/ta/utdid2/device/a;->a:Ljava/lang/String;

    return-object v0
.end method

.method private c(Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcom/ta/utdid2/device/a;->c:Ljava/lang/String;

    return-void
.end method

.method private d()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcom/ta/utdid2/device/a;->b:Ljava/lang/String;

    return-object v0
.end method

.method private d(Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcom/ta/utdid2/device/a;->d:Ljava/lang/String;

    return-void
.end method

.method private e()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcom/ta/utdid2/device/a;->c:Ljava/lang/String;

    return-object v0
.end method

.method private f()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcom/ta/utdid2/device/a;->d:Ljava/lang/String;

    return-object v0
.end method
