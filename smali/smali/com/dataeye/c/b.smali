.class public Lcom/dataeye/c/b;
.super Ljava/lang/Object;


# static fields
.field static final a:[Ljava/lang/String;

.field public static b:Z

.field public static c:J

.field public static d:J

.field public static e:J

.field public static f:J

.field public static g:J

.field public static h:I

.field public static i:I

.field public static j:Ljava/lang/String;

.field public static k:Ljava/util/LinkedList;

.field public static l:Ljava/lang/String;

.field public static m:I

.field public static n:J

.field private static o:Landroid/content/Context;


# direct methods
.method static constructor <clinit>()V
    .locals 5

    const/4 v4, 0x1

    const/4 v3, 0x0

    const/4 v0, 0x3

    new-array v0, v0, [Ljava/lang/String;

    const-string v1, "android.permission.INTERNET"

    aput-object v1, v0, v3

    const-string v1, "android.permission.ACCESS_NETWORK_STATE"

    aput-object v1, v0, v4

    const/4 v1, 0x2

    const-string v2, "android.permission.READ_PHONE_STATE"

    aput-object v2, v0, v1

    sput-object v0, Lcom/dataeye/c/b;->a:[Ljava/lang/String;

    sput-boolean v3, Lcom/dataeye/c/b;->b:Z

    const-wide/16 v0, 0x7530

    sput-wide v0, Lcom/dataeye/c/b;->c:J

    invoke-static {}, Lcom/dataeye/c/ab;->b()I

    move-result v0

    sput v0, Lcom/dataeye/c/b;->h:I

    sput v4, Lcom/dataeye/c/b;->i:I

    const-string v0, ""

    sput-object v0, Lcom/dataeye/c/b;->j:Ljava/lang/String;

    new-instance v0, Ljava/util/LinkedList;

    invoke-direct {v0}, Ljava/util/LinkedList;-><init>()V

    sput-object v0, Lcom/dataeye/c/b;->k:Ljava/util/LinkedList;

    const-string v0, "rd.gdatacube.net"

    sput-object v0, Lcom/dataeye/c/b;->l:Ljava/lang/String;

    sput v3, Lcom/dataeye/c/b;->m:I

    const-wide/32 v0, 0xea60

    sput-wide v0, Lcom/dataeye/c/b;->n:J

    return-void
.end method

.method public static a(J)I
    .locals 2

    const-wide/16 v0, 0x3e8

    div-long v0, p0, v0

    long-to-int v0, v0

    return v0
.end method

.method public static a(Lcom/dataeye/a/a;JLandroid/database/sqlite/SQLiteDatabase;ZZ)Lcom/dataeye/a/e;
    .locals 2

    new-instance v0, Lcom/dataeye/a/e;

    invoke-direct {v0}, Lcom/dataeye/a/e;-><init>()V

    invoke-static {p0, v0, p5}, Lcom/dataeye/c/b;->a(Lcom/dataeye/a/a;Lcom/dataeye/a/e;Z)V

    invoke-static {p0, p1, p2, p4, v0}, Lcom/dataeye/c/b;->a(Lcom/dataeye/a/a;JZLcom/dataeye/a/e;)V

    iget-object v1, p0, Lcom/dataeye/a/a;->a:Ljava/lang/String;

    invoke-static {v1, p3, p5, v0}, Lcom/dataeye/c/b;->a(Ljava/lang/String;Landroid/database/sqlite/SQLiteDatabase;ZLcom/dataeye/a/e;)V

    return-object v0
.end method

.method public static final a(Lcom/dataeye/a/a;J)Lcom/dataeye/a/j;
    .locals 6

    invoke-static {p1, p2}, Lcom/dataeye/c/b;->a(J)I

    move-result v1

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    const-wide/16 v4, 0x3e8

    div-long/2addr v2, v4

    int-to-long v4, v1

    sub-long/2addr v2, v4

    long-to-int v0, v2

    add-int/lit8 v2, v0, 0x1

    new-instance v3, Lcom/dataeye/a/j;

    iget v4, p0, Lcom/dataeye/a/a;->g:I

    invoke-static {p0}, Lcom/dataeye/c/a;->a(Lcom/dataeye/a/a;)Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 v0, 0x0

    :goto_0
    invoke-direct {v3, v1, v2, v4, v0}, Lcom/dataeye/a/j;-><init>(IIIZ)V

    return-object v3

    :cond_0
    const/4 v0, 0x1

    goto :goto_0
.end method

.method public static final a()V
    .locals 6

    const-wide/16 v4, 0x0

    sget-wide v0, Lcom/dataeye/c/b;->d:J

    cmp-long v0, v0, v4

    if-eqz v0, :cond_0

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    sget-wide v2, Lcom/dataeye/c/b;->g:J

    sub-long/2addr v0, v2

    sget-wide v2, Lcom/dataeye/c/b;->c:J

    cmp-long v0, v0, v2

    if-gtz v0, :cond_0

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    sget-wide v2, Lcom/dataeye/c/b;->g:J

    sub-long/2addr v0, v2

    cmp-long v0, v0, v4

    if-gtz v0, :cond_1

    :cond_0
    invoke-static {}, Lcom/dataeye/c/b;->b()V

    :cond_1
    return-void
.end method

.method public static a(I)V
    .locals 2

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    sput-wide v0, Lcom/dataeye/c/b;->f:J

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "DC_SPENDTIMEINLEVELS_"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/dataeye/c/y;->a(Ljava/lang/String;)Z

    return-void
.end method

.method public static a(Landroid/content/Context;)V
    .locals 1

    sget-object v0, Lcom/dataeye/c/b;->o:Landroid/content/Context;

    if-nez v0, :cond_0

    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    sput-object v0, Lcom/dataeye/c/b;->o:Landroid/content/Context;

    :cond_0
    return-void
.end method

.method public static a(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V
    .locals 3

    const/4 v2, 0x1

    invoke-static {p0}, Lcom/dataeye/c/b;->a(Landroid/content/Context;)V

    invoke-static {}, Lcom/dataeye/c/t;->a()V

    sget-boolean v0, Lcom/dataeye/c/b;->b:Z

    if-eqz v0, :cond_1

    :cond_0
    :goto_0
    return-void

    :cond_1
    sget-object v0, Lcom/dataeye/c/b;->a:[Ljava/lang/String;

    invoke-static {p0, v0}, Lcom/dataeye/c/ab;->a(Landroid/content/Context;[Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_2

    const-string v0, "DataEye SDK init fail , Please check uses-permission in AndroidManifest.xml. "

    invoke-static {v0}, Lcom/dataeye/c/t;->c(Ljava/lang/String;)V

    goto :goto_0

    :cond_2
    sget-object v0, Lcom/dataeye/c/b;->j:Ljava/lang/String;

    invoke-static {p0, p1, p2, v0}, Lcom/dataeye/c/w;->a(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    sget-boolean v0, Lcom/dataeye/c/w;->a:Z

    if-eqz v0, :cond_0

    sget-object v0, Lcom/dataeye/c/w;->c:Ljava/lang/String;

    invoke-static {p0, v0}, Lcom/dataeye/c/y;->a(Landroid/content/Context;Ljava/lang/String;)V

    sget-object v0, Lcom/dataeye/c/w;->c:Ljava/lang/String;

    invoke-static {p0, v0}, Lcom/dataeye/c/r;->a(Landroid/content/Context;Ljava/lang/String;)V

    invoke-static {}, Lcom/dataeye/c/b;->i()V

    invoke-static {}, Lcom/dataeye/c/o;->b()V

    new-instance v0, Lcom/dataeye/c/c;

    invoke-direct {v0}, Lcom/dataeye/c/c;-><init>()V

    invoke-static {v0}, Lcom/dataeye/c/o;->a(Lcom/dataeye/c/z;)V

    const/4 v0, 0x0

    invoke-static {v2, v0}, Lcom/dataeye/c/o;->a(ZLcom/dataeye/ConfigParamsUpdateListener;)V

    invoke-static {}, Lcom/dataeye/c/b;->h()V

    invoke-static {p0}, Lcom/dataeye/c/a;->a(Landroid/content/Context;)V

    invoke-static {p0}, Lcom/dataeye/c/ad;->a(Landroid/content/Context;)V

    invoke-static {}, Lcom/dataeye/c/b;->o()V

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "DataEye SDK init success!  AppId:"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object v1, Lcom/dataeye/c/w;->c:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "; ChannelId:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    sget-object v1, Lcom/dataeye/c/w;->d:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "; AppVersion:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    sget-object v1, Lcom/dataeye/c/w;->b:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "; ReportMode:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    sget v0, Lcom/dataeye/c/b;->i:I

    if-ne v0, v2, :cond_3

    const-string v0, "DC_DEFAULT"

    :goto_1
    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/dataeye/c/t;->b(Ljava/lang/String;)V

    sput-boolean v2, Lcom/dataeye/c/b;->b:Z

    goto :goto_0

    :cond_3
    const-string v0, "DC_AFTER_LOGIN"

    goto :goto_1
.end method

.method private static a(Lcom/dataeye/a/a;JZLcom/dataeye/a/e;)V
    .locals 2

    if-eqz p3, :cond_0

    :goto_0
    return-void

    :cond_0
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p4, Lcom/dataeye/a/e;->o:Ljava/util/ArrayList;

    iget-object v0, p4, Lcom/dataeye/a/e;->o:Ljava/util/ArrayList;

    invoke-static {p0, p1, p2}, Lcom/dataeye/c/b;->a(Lcom/dataeye/a/a;J)Lcom/dataeye/a/j;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_0
.end method

.method private static a(Lcom/dataeye/a/a;Lcom/dataeye/a/e;Z)V
    .locals 5

    sget-object v0, Lcom/dataeye/c/w;->c:Ljava/lang/String;

    iput-object v0, p1, Lcom/dataeye/a/e;->b:Ljava/lang/String;

    sget-object v0, Lcom/dataeye/c/w;->d:Ljava/lang/String;

    iput-object v0, p1, Lcom/dataeye/a/e;->c:Ljava/lang/String;

    sget-object v0, Lcom/dataeye/c/w;->b:Ljava/lang/String;

    iput-object v0, p1, Lcom/dataeye/a/e;->r:Ljava/lang/String;

    invoke-static {}, Lcom/dataeye/c/a;->b()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p1, Lcom/dataeye/a/e;->d:Ljava/lang/String;

    if-nez p2, :cond_0

    iget-object v0, p0, Lcom/dataeye/a/a;->a:Ljava/lang/String;

    iput-object v0, p1, Lcom/dataeye/a/e;->e:Ljava/lang/String;

    iget v0, p0, Lcom/dataeye/a/a;->d:I

    iput v0, p1, Lcom/dataeye/a/e;->f:I

    iget v0, p0, Lcom/dataeye/a/a;->e:I

    iput v0, p1, Lcom/dataeye/a/e;->g:I

    iget v0, p0, Lcom/dataeye/a/a;->f:I

    iput v0, p1, Lcom/dataeye/a/e;->h:I

    iget-object v0, p0, Lcom/dataeye/a/a;->h:Ljava/lang/String;

    iput-object v0, p1, Lcom/dataeye/a/e;->i:Ljava/lang/String;

    :cond_0
    sget-object v0, Lcom/dataeye/c/w;->e:Lcom/dataeye/a/f;

    iget-object v0, v0, Lcom/dataeye/a/f;->i:Ljava/lang/String;

    iput-object v0, p1, Lcom/dataeye/a/e;->j:Ljava/lang/String;

    sget-object v0, Lcom/dataeye/c/w;->e:Lcom/dataeye/a/f;

    iget-object v0, v0, Lcom/dataeye/a/f;->h:Ljava/lang/String;

    iput-object v0, p1, Lcom/dataeye/a/e;->k:Ljava/lang/String;

    sget-object v0, Lcom/dataeye/c/w;->e:Lcom/dataeye/a/f;

    iget-object v0, v0, Lcom/dataeye/a/f;->e:Ljava/lang/String;

    iput-object v0, p1, Lcom/dataeye/a/e;->l:Ljava/lang/String;

    sget-object v0, Lcom/dataeye/c/b;->o:Landroid/content/Context;

    invoke-static {v0}, Lcom/dataeye/c/ab;->e(Landroid/content/Context;)I

    move-result v0

    iput v0, p1, Lcom/dataeye/a/e;->m:I

    const-string v0, ""

    iput-object v0, p1, Lcom/dataeye/a/e;->t:Ljava/lang/String;

    iget-wide v0, p0, Lcom/dataeye/a/a;->l:J

    iput-wide v0, p1, Lcom/dataeye/a/e;->w:J

    iget-object v0, p0, Lcom/dataeye/a/a;->k:Ljava/lang/String;

    iput-object v0, p1, Lcom/dataeye/a/e;->v:Ljava/lang/String;

    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    iput-object v0, p1, Lcom/dataeye/a/e;->A:Ljava/util/Map;

    iget-object v0, p1, Lcom/dataeye/a/e;->A:Ljava/util/Map;

    const-string v1, "WIFIMAC"

    sget-object v2, Lcom/dataeye/c/b;->o:Landroid/content/Context;

    invoke-static {v2}, Lcom/dataeye/c/ab;->g(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v2

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    iget-object v0, p1, Lcom/dataeye/a/e;->A:Ljava/util/Map;

    const-string v1, "IMEI"

    sget-object v2, Lcom/dataeye/c/b;->o:Landroid/content/Context;

    invoke-static {v2}, Lcom/dataeye/c/ab;->j(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v2

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    iget-object v0, p1, Lcom/dataeye/a/e;->A:Ljava/util/Map;

    const-string v1, "IMSI"

    sget-object v2, Lcom/dataeye/c/b;->o:Landroid/content/Context;

    invoke-static {v2}, Lcom/dataeye/c/ab;->k(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v2

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    iget-object v0, p1, Lcom/dataeye/a/e;->A:Ljava/util/Map;

    const-string v1, "SIM_OPERATOR"

    sget-object v2, Lcom/dataeye/c/b;->o:Landroid/content/Context;

    invoke-static {v2}, Lcom/dataeye/c/ab;->c(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v2

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    iget-object v0, p1, Lcom/dataeye/a/e;->A:Ljava/util/Map;

    const-string v1, "SIM_OPERATOR_ISO"

    sget-object v2, Lcom/dataeye/c/b;->o:Landroid/content/Context;

    invoke-static {v2}, Lcom/dataeye/c/ab;->d(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v2

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    iget-object v1, p1, Lcom/dataeye/a/e;->A:Ljava/util/Map;

    const-string v2, "REPORTMODE"

    sget v0, Lcom/dataeye/c/b;->i:I

    const/4 v3, 0x1

    if-ne v0, v3, :cond_5

    const-string v0, "DEFAULT"

    :goto_0
    invoke-interface {v1, v2, v0}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    iget-object v0, p1, Lcom/dataeye/a/e;->A:Ljava/util/Map;

    const-string v1, "INVOKELOG"

    invoke-static {}, Lcom/dataeye/c/s;->b()Ljava/lang/String;

    move-result-object v2

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    iget-object v0, p1, Lcom/dataeye/a/e;->A:Ljava/util/Map;

    const-string v1, "SESSIONTIME"

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {}, Lcom/dataeye/c/b;->g()I

    move-result v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    iget-object v0, p1, Lcom/dataeye/a/e;->A:Ljava/util/Map;

    const-string v1, "TIMEZONE"

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {}, Lcom/dataeye/c/ab;->j()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    iget-object v0, p1, Lcom/dataeye/a/e;->A:Ljava/util/Map;

    const-string v1, "PACKAGE"

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    sget-object v3, Lcom/dataeye/c/b;->o:Landroid/content/Context;

    invoke-static {v3}, Lcom/dataeye/c/ab;->h(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    sget-wide v0, Lcom/dataeye/c/b;->n:J

    const-wide/32 v2, 0xea60

    cmp-long v0, v0, v2

    if-eqz v0, :cond_1

    iget-object v0, p1, Lcom/dataeye/a/e;->A:Ljava/util/Map;

    const-string v1, "UPLOADINTERVAL"

    new-instance v2, Ljava/lang/StringBuilder;

    sget-wide v3, Lcom/dataeye/c/b;->n:J

    invoke-static {v3, v4}, Ljava/lang/String;->valueOf(J)Ljava/lang/String;

    move-result-object v3

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_1
    if-nez p2, :cond_4

    new-instance v0, Lcom/dataeye/a/l;

    invoke-direct {v0}, Lcom/dataeye/a/l;-><init>()V

    invoke-static {}, Lcom/dataeye/c/a;->a()Z

    move-result v1

    if-nez v1, :cond_2

    invoke-static {}, Lcom/dataeye/c/ab;->b()I

    move-result v1

    iput v1, v0, Lcom/dataeye/a/l;->b:I

    sget-object v1, Lcom/dataeye/c/w;->e:Lcom/dataeye/a/f;

    iput-object v1, p1, Lcom/dataeye/a/e;->y:Lcom/dataeye/a/f;

    :cond_2
    invoke-static {p0}, Lcom/dataeye/c/a;->a(Lcom/dataeye/a/a;)Z

    move-result v1

    if-nez v1, :cond_3

    invoke-static {}, Lcom/dataeye/c/ab;->b()I

    move-result v1

    iput v1, v0, Lcom/dataeye/a/l;->c:I

    sget v1, Lcom/dataeye/c/a;->l:I

    iput v1, v0, Lcom/dataeye/a/l;->d:I

    :cond_3
    invoke-static {}, Lcom/dataeye/c/a;->g()Lcom/dataeye/a/a;

    move-result-object v1

    iget-object v1, v1, Lcom/dataeye/a/a;->b:Ljava/lang/String;

    iput-object v1, v0, Lcom/dataeye/a/l;->a:Ljava/lang/String;

    iput-object v0, p1, Lcom/dataeye/a/e;->n:Lcom/dataeye/a/l;

    :cond_4
    return-void

    :cond_5
    const-string v0, "AFTER_LOGIN"

    goto/16 :goto_0
.end method

.method public static a(Lcom/dataeye/a/g;)V
    .locals 2

    invoke-static {}, Lcom/dataeye/c/a;->g()Lcom/dataeye/a/a;

    move-result-object v0

    if-eqz v0, :cond_0

    invoke-static {}, Lcom/dataeye/c/r;->a()Lcom/dataeye/c/r;

    move-result-object v0

    invoke-static {}, Lcom/dataeye/c/a;->f()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1, p0}, Lcom/dataeye/c/r;->a(Ljava/lang/String;Lcom/dataeye/a/g;)V

    :cond_0
    return-void
.end method

.method public static a(Lcom/dataeye/a/h;)V
    .locals 2

    invoke-static {}, Lcom/dataeye/c/a;->g()Lcom/dataeye/a/a;

    move-result-object v0

    if-eqz v0, :cond_0

    invoke-static {}, Lcom/dataeye/c/r;->a()Lcom/dataeye/c/r;

    move-result-object v0

    invoke-static {}, Lcom/dataeye/c/a;->f()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1, p0}, Lcom/dataeye/c/r;->a(Ljava/lang/String;Lcom/dataeye/a/h;)V

    :cond_0
    return-void
.end method

.method public static a(Lcom/dataeye/a/i;)V
    .locals 2

    invoke-static {}, Lcom/dataeye/c/a;->g()Lcom/dataeye/a/a;

    move-result-object v0

    if-eqz v0, :cond_0

    invoke-static {}, Lcom/dataeye/c/r;->a()Lcom/dataeye/c/r;

    move-result-object v0

    invoke-static {}, Lcom/dataeye/c/a;->f()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1, p0}, Lcom/dataeye/c/r;->a(Ljava/lang/String;Lcom/dataeye/a/i;)V

    :cond_0
    return-void
.end method

.method public static a(Lcom/dataeye/a/k;)V
    .locals 2

    invoke-static {}, Lcom/dataeye/c/a;->g()Lcom/dataeye/a/a;

    move-result-object v0

    if-eqz v0, :cond_0

    invoke-static {}, Lcom/dataeye/c/r;->a()Lcom/dataeye/c/r;

    move-result-object v0

    invoke-static {}, Lcom/dataeye/c/a;->f()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1, p0}, Lcom/dataeye/c/r;->a(Ljava/lang/String;Lcom/dataeye/a/k;)V

    :cond_0
    return-void
.end method

.method private static a(Ljava/lang/String;Landroid/database/sqlite/SQLiteDatabase;ZLcom/dataeye/a/e;)V
    .locals 2

    invoke-static {}, Lcom/dataeye/c/r;->b()V

    if-nez p2, :cond_2

    invoke-static {}, Lcom/dataeye/c/r;->a()Lcom/dataeye/c/r;

    move-result-object v0

    invoke-virtual {v0, p0, p1}, Lcom/dataeye/c/r;->a(Ljava/lang/String;Landroid/database/sqlite/SQLiteDatabase;)Ljava/util/ArrayList;

    move-result-object v0

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v1

    if-lez v1, :cond_0

    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    iput-object v1, p3, Lcom/dataeye/a/e;->p:Ljava/util/ArrayList;

    iget-object v1, p3, Lcom/dataeye/a/e;->p:Ljava/util/ArrayList;

    invoke-virtual {v1, v0}, Ljava/util/ArrayList;->addAll(Ljava/util/Collection;)Z

    invoke-virtual {v0}, Ljava/util/ArrayList;->clear()V

    :cond_0
    invoke-static {}, Lcom/dataeye/c/r;->a()Lcom/dataeye/c/r;

    move-result-object v0

    invoke-virtual {v0, p0, p1}, Lcom/dataeye/c/r;->c(Ljava/lang/String;Landroid/database/sqlite/SQLiteDatabase;)Ljava/util/ArrayList;

    move-result-object v0

    if-eqz v0, :cond_1

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v1

    if-lez v1, :cond_1

    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    iput-object v1, p3, Lcom/dataeye/a/e;->q:Ljava/util/ArrayList;

    iget-object v1, p3, Lcom/dataeye/a/e;->q:Ljava/util/ArrayList;

    invoke-virtual {v1, v0}, Ljava/util/ArrayList;->addAll(Ljava/util/Collection;)Z

    invoke-virtual {v0}, Ljava/util/ArrayList;->clear()V

    :cond_1
    invoke-static {}, Lcom/dataeye/c/r;->a()Lcom/dataeye/c/r;

    move-result-object v0

    invoke-virtual {v0, p0, p1}, Lcom/dataeye/c/r;->b(Ljava/lang/String;Landroid/database/sqlite/SQLiteDatabase;)Ljava/util/ArrayList;

    move-result-object v0

    if-eqz v0, :cond_2

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v1

    if-lez v1, :cond_2

    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    iput-object v1, p3, Lcom/dataeye/a/e;->s:Ljava/util/ArrayList;

    iget-object v1, p3, Lcom/dataeye/a/e;->s:Ljava/util/ArrayList;

    invoke-virtual {v1, v0}, Ljava/util/ArrayList;->addAll(Ljava/util/Collection;)Z

    invoke-virtual {v0}, Ljava/util/ArrayList;->clear()V

    :cond_2
    invoke-static {}, Lcom/dataeye/c/r;->a()Lcom/dataeye/c/r;

    move-result-object v0

    invoke-virtual {v0, p1}, Lcom/dataeye/c/r;->a(Landroid/database/sqlite/SQLiteDatabase;)Ljava/util/ArrayList;

    move-result-object v0

    if-eqz v0, :cond_3

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v1

    if-lez v1, :cond_3

    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    iput-object v1, p3, Lcom/dataeye/a/e;->s:Ljava/util/ArrayList;

    iget-object v1, p3, Lcom/dataeye/a/e;->s:Ljava/util/ArrayList;

    invoke-virtual {v1, v0}, Ljava/util/ArrayList;->addAll(Ljava/util/Collection;)Z

    invoke-virtual {v0}, Ljava/util/ArrayList;->clear()V

    :cond_3
    invoke-static {}, Lcom/dataeye/c/r;->a()Lcom/dataeye/c/r;

    move-result-object v0

    invoke-virtual {v0, p1}, Lcom/dataeye/c/r;->b(Landroid/database/sqlite/SQLiteDatabase;)Ljava/util/ArrayList;

    move-result-object v0

    if-eqz v0, :cond_4

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v1

    if-lez v1, :cond_4

    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    iput-object v1, p3, Lcom/dataeye/a/e;->u:Ljava/util/ArrayList;

    iget-object v1, p3, Lcom/dataeye/a/e;->u:Ljava/util/ArrayList;

    invoke-virtual {v1, v0}, Ljava/util/ArrayList;->addAll(Ljava/util/Collection;)Z

    invoke-virtual {v0}, Ljava/util/ArrayList;->clear()V

    :cond_4
    invoke-static {}, Lcom/dataeye/c/r;->a()Lcom/dataeye/c/r;

    move-result-object v0

    sget-object v1, Lcom/dataeye/c/r;->a:Ljava/util/ArrayList;

    invoke-virtual {v0, p1, v1}, Lcom/dataeye/c/r;->a(Landroid/database/sqlite/SQLiteDatabase;Ljava/util/List;)V

    invoke-static {}, Lcom/dataeye/c/r;->b()V

    return-void
.end method

.method public static a(Ljava/lang/String;Lcom/dataeye/a/h;)V
    .locals 1

    invoke-static {}, Lcom/dataeye/c/ab;->b()I

    move-result v0

    iput v0, p1, Lcom/dataeye/a/h;->e:I

    invoke-virtual {p1}, Lcom/dataeye/a/h;->a()[B

    move-result-object v0

    invoke-static {v0}, Lcom/dataeye/b/a;->a([B)Ljava/lang/String;

    move-result-object v0

    invoke-static {p0, v0}, Lcom/dataeye/c/y;->b(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static a(Z)V
    .locals 3

    const-string v0, "Invoke CacheFactory.uploadAsync start [A]"

    invoke-static {v0}, Lcom/dataeye/c/t;->a(Ljava/lang/String;)V

    if-nez p0, :cond_0

    :try_start_0
    sget v0, Lcom/dataeye/c/b;->i:I

    const/4 v1, 0x2

    if-ne v0, v1, :cond_1

    invoke-static {}, Lcom/dataeye/c/a;->g()Lcom/dataeye/a/a;

    move-result-object v0

    if-eqz v0, :cond_1

    invoke-static {}, Lcom/dataeye/c/a;->g()Lcom/dataeye/a/a;

    move-result-object v0

    iget-boolean v0, v0, Lcom/dataeye/a/a;->c:Z

    if-nez v0, :cond_1

    const-string v0, "Invoke UploadAsync ignored, because reportMode= AFTER_LOGIN and login=false"

    invoke-static {v0}, Lcom/dataeye/c/t;->a(Ljava/lang/String;)V

    :goto_0
    return-void

    :cond_0
    const-string v0, "DataEye SDK upload device active info!"

    invoke-static {v0}, Lcom/dataeye/c/t;->a(Ljava/lang/String;)V

    :cond_1
    new-instance v0, Lcom/dataeye/c/e;

    invoke-direct {v0, p0}, Lcom/dataeye/c/e;-><init>(Z)V

    invoke-static {v0}, Lcom/dataeye/c/h;->a(Lcom/dataeye/c/k;)V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "DataEye SDK upload data error(A) , reason"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1, v0}, Lcom/dataeye/c/t;->a(Ljava/lang/String;Ljava/lang/Throwable;)V

    goto :goto_0
.end method

.method public static a(Landroid/content/Context;Landroid/database/sqlite/SQLiteDatabase;)Z
    .locals 3

    invoke-static {}, Lcom/dataeye/c/r;->a()Lcom/dataeye/c/r;

    move-result-object v0

    invoke-virtual {v0, p1}, Lcom/dataeye/c/r;->c(Landroid/database/sqlite/SQLiteDatabase;)Ljava/util/HashMap;

    move-result-object v0

    invoke-virtual {v0}, Ljava/util/HashMap;->size()I

    move-result v1

    if-eqz v1, :cond_0

    invoke-virtual {v0}, Ljava/util/HashMap;->entrySet()Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :goto_0
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-nez v0, :cond_1

    :cond_0
    :goto_1
    const/4 v0, 0x0

    return v0

    :cond_1
    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/Map$Entry;

    invoke-interface {v0}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Integer;

    invoke-interface {v0}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/dataeye/a/e;

    invoke-static {p0, v0}, Lcom/dataeye/c/b;->a(Landroid/content/Context;Lcom/dataeye/a/e;)Z

    move-result v0

    if-eqz v0, :cond_2

    invoke-static {}, Lcom/dataeye/c/r;->a()Lcom/dataeye/c/r;

    move-result-object v0

    invoke-virtual {v0, p1, v1}, Lcom/dataeye/c/r;->a(Landroid/database/sqlite/SQLiteDatabase;Ljava/lang/Integer;)V

    const-string v0, "DataEye SDK upload data success!(H)"

    invoke-static {v0}, Lcom/dataeye/c/t;->b(Ljava/lang/String;)V

    goto :goto_0

    :cond_2
    const-string v0, "DataEye SDK upload data fail!(H)"

    invoke-static {v0}, Lcom/dataeye/c/t;->b(Ljava/lang/String;)V

    goto :goto_1
.end method

.method private static a(Landroid/content/Context;Lcom/dataeye/a/e;)Z
    .locals 13

    const/4 v9, 0x1

    const/4 v8, 0x0

    sget-object v0, Lcom/dataeye/c/b;->o:Landroid/content/Context;

    invoke-static {v0}, Lcom/dataeye/c/ab;->m(Landroid/content/Context;)Z

    move-result v0

    if-nez v0, :cond_0

    const-string v0, "Invoke CacheFactory.doUpload terminate, reason: network not connected "

    invoke-static {v0}, Lcom/dataeye/c/t;->a(Ljava/lang/String;)V

    move v0, v8

    :goto_0
    return v0

    :cond_0
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v10

    invoke-static {p0}, Lcom/dataeye/c/ab;->n(Landroid/content/Context;)Z

    move-result v12

    :try_start_0
    sget-object v0, Lcom/dataeye/c/b;->l:Ljava/lang/String;

    invoke-static {v0, p1}, Lcom/dataeye/c/ab;->a(Ljava/lang/String;Lcom/dataeye/b/f;)Z

    move-result v0

    if-eqz v0, :cond_2

    if-eqz v12, :cond_1

    const-string v0, "_dc_oss_def_wifi"

    :goto_1
    const-string v1, "upload"

    const/4 v2, 0x1

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v3

    sub-long/2addr v3, v10

    invoke-virtual {p1}, Lcom/dataeye/a/e;->a()[B

    move-result-object v5

    array-length v5, v5

    int-to-long v5, v5

    sget-object v7, Lcom/dataeye/c/b;->l:Ljava/lang/String;

    invoke-static/range {v0 .. v7}, Lcom/dataeye/c/v;->a(Ljava/lang/String;Ljava/lang/String;ZJJLjava/lang/String;)V

    invoke-static {}, Lcom/dataeye/c/ab;->b()I

    move-result v0

    sput v0, Lcom/dataeye/c/b;->h:I

    move v0, v9

    goto :goto_0

    :cond_1
    const-string v0, "_dc_oss_def_mobi"

    goto :goto_1

    :cond_2
    if-eqz v12, :cond_3

    const-string v0, "_dc_oss_def_wifi"

    :goto_2
    const-string v1, "upload"

    const/4 v2, 0x0

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v3

    sub-long/2addr v3, v10

    invoke-virtual {p1}, Lcom/dataeye/a/e;->a()[B

    move-result-object v5

    array-length v5, v5

    int-to-long v5, v5

    sget-object v7, Lcom/dataeye/c/b;->l:Ljava/lang/String;

    invoke-static/range {v0 .. v7}, Lcom/dataeye/c/v;->a(Ljava/lang/String;Ljava/lang/String;ZJJLjava/lang/String;)V

    :goto_3
    move v0, v8

    goto :goto_0

    :cond_3
    const-string v0, "_dc_oss_def_mobi"
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_2

    :catch_0
    move-exception v0

    move-object v9, v0

    if-eqz v12, :cond_4

    :try_start_1
    const-string v0, "_dc_oss_def_wifi"

    :goto_4
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "upload:"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v9}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const/4 v2, 0x0

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v3

    sub-long/2addr v3, v10

    invoke-virtual {p1}, Lcom/dataeye/a/e;->a()[B

    move-result-object v5

    array-length v5, v5

    int-to-long v5, v5

    sget-object v7, Lcom/dataeye/c/b;->l:Ljava/lang/String;

    invoke-static/range {v0 .. v7}, Lcom/dataeye/c/v;->a(Ljava/lang/String;Ljava/lang/String;ZJJLjava/lang/String;)V

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "Invoke CacheFactory.doUploadHistory error, reason:"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v9}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0, v9}, Lcom/dataeye/c/t;->a(Ljava/lang/String;Ljava/lang/Throwable;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_3

    :catchall_0
    move-exception v0

    throw v0

    :cond_4
    :try_start_2
    const-string v0, "_dc_oss_def_mobi"
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    goto :goto_4
.end method

.method public static a(Landroid/database/sqlite/SQLiteDatabase;)Z
    .locals 1

    sget-object v0, Lcom/dataeye/c/b;->o:Landroid/content/Context;

    invoke-static {v0, p0}, Lcom/dataeye/c/b;->a(Landroid/content/Context;Landroid/database/sqlite/SQLiteDatabase;)Z

    move-result v0

    return v0
.end method

.method public static a(Lcom/dataeye/a/a;Landroid/database/sqlite/SQLiteDatabase;Z)Z
    .locals 7

    const/4 v6, 0x0

    if-nez p0, :cond_0

    move v0, v6

    :goto_0
    return v0

    :cond_0
    iget-object v0, p0, Lcom/dataeye/a/a;->a:Ljava/lang/String;

    :try_start_0
    const-string v1, "_DESelf_DEFAULT_ACCOUNTID"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    if-nez p2, :cond_1

    const-string v0, "DataEye SDK upload data  stop, reason : accountid is default accountid"

    invoke-static {v0}, Lcom/dataeye/c/t;->a(Ljava/lang/String;)V

    const/4 v0, 0x1

    goto :goto_0

    :cond_1
    sget-wide v1, Lcom/dataeye/c/b;->d:J

    const/4 v5, 0x0

    move-object v0, p0

    move-object v3, p1

    move v4, p2

    invoke-static/range {v0 .. v5}, Lcom/dataeye/c/b;->a(Lcom/dataeye/a/a;JLandroid/database/sqlite/SQLiteDatabase;ZZ)Lcom/dataeye/a/e;

    move-result-object v0

    const/4 v1, 0x0

    invoke-static {v0, p1, v1}, Lcom/dataeye/c/b;->a(Lcom/dataeye/a/e;Landroid/database/sqlite/SQLiteDatabase;Z)Z

    move-result v0

    if-eqz v0, :cond_2

    const-string v1, "DataEye SDK upload data success!(A)"

    invoke-static {v1}, Lcom/dataeye/c/t;->b(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "DataEye SDK upload data error(A) , reason:"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1, v0}, Lcom/dataeye/c/t;->a(Ljava/lang/String;Ljava/lang/Throwable;)V

    move v0, v6

    goto :goto_0

    :cond_2
    :try_start_1
    const-string v1, "DataEye SDK upload data fail!(A)"

    invoke-static {v1}, Lcom/dataeye/c/t;->b(Ljava/lang/String;)V
    :try_end_1
    .catch Ljava/lang/Throwable; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0
.end method

.method private static a(Lcom/dataeye/a/e;Landroid/database/sqlite/SQLiteDatabase;Z)Z
    .locals 13

    sget-object v0, Lcom/dataeye/c/b;->o:Landroid/content/Context;

    invoke-static {v0}, Lcom/dataeye/c/ab;->m(Landroid/content/Context;)Z

    move-result v0

    if-nez v0, :cond_0

    const-string v0, "Invoke CacheFactory.doUpload terminate, reason: network not connected "

    invoke-static {v0}, Lcom/dataeye/c/t;->a(Ljava/lang/String;)V

    const/4 v0, 0x0

    :goto_0
    return v0

    :cond_0
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v10

    sget-object v0, Lcom/dataeye/c/b;->o:Landroid/content/Context;

    invoke-static {v0}, Lcom/dataeye/c/ab;->n(Landroid/content/Context;)Z

    move-result v12

    const/4 v8, 0x1

    :try_start_0
    sget-object v0, Lcom/dataeye/c/b;->l:Ljava/lang/String;

    invoke-static {v0, p0}, Lcom/dataeye/c/ab;->a(Ljava/lang/String;Lcom/dataeye/b/f;)Z

    move-result v0

    if-eqz v0, :cond_4

    if-eqz v12, :cond_3

    const-string v0, "_dc_oss_def_wifi"

    :goto_1
    const-string v1, "upload"

    const/4 v2, 0x1

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v3

    sub-long/2addr v3, v10

    invoke-virtual {p0}, Lcom/dataeye/a/e;->a()[B

    move-result-object v5

    array-length v5, v5

    int-to-long v5, v5

    sget-object v7, Lcom/dataeye/c/b;->l:Ljava/lang/String;

    invoke-static/range {v0 .. v7}, Lcom/dataeye/c/v;->a(Ljava/lang/String;Ljava/lang/String;ZJJLjava/lang/String;)V

    if-nez p2, :cond_2

    iget-object v0, p0, Lcom/dataeye/a/e;->n:Lcom/dataeye/a/l;

    iget v0, v0, Lcom/dataeye/a/l;->b:I

    if-lez v0, :cond_1

    iget-object v0, p0, Lcom/dataeye/a/e;->n:Lcom/dataeye/a/l;

    iget v0, v0, Lcom/dataeye/a/l;->b:I

    invoke-static {v0}, Lcom/dataeye/c/a;->a(I)V

    :cond_1
    iget-object v0, p0, Lcom/dataeye/a/e;->n:Lcom/dataeye/a/l;

    iget v0, v0, Lcom/dataeye/a/l;->c:I

    if-lez v0, :cond_2

    iget-object v0, p0, Lcom/dataeye/a/e;->n:Lcom/dataeye/a/l;

    iget v0, v0, Lcom/dataeye/a/l;->c:I

    invoke-static {v0}, Lcom/dataeye/c/a;->f(I)V

    :cond_2
    invoke-static {}, Lcom/dataeye/c/ab;->b()I

    move-result v0

    sput v0, Lcom/dataeye/c/b;->h:I

    move v0, v8

    goto :goto_0

    :cond_3
    const-string v0, "_dc_oss_def_mobi"

    goto :goto_1

    :cond_4
    if-eqz v12, :cond_5

    const-string v0, "_dc_oss_def_wifi"

    :goto_2
    const-string v1, "upload"

    const/4 v2, 0x0

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v3

    sub-long/2addr v3, v10

    invoke-virtual {p0}, Lcom/dataeye/a/e;->a()[B

    move-result-object v5

    array-length v5, v5

    int-to-long v5, v5

    sget-object v7, Lcom/dataeye/c/b;->l:Ljava/lang/String;

    invoke-static/range {v0 .. v7}, Lcom/dataeye/c/v;->a(Ljava/lang/String;Ljava/lang/String;ZJJLjava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    const/4 v0, 0x0

    invoke-static {}, Lcom/dataeye/c/r;->a()Lcom/dataeye/c/r;

    move-result-object v1

    invoke-virtual {v1, p0, p1}, Lcom/dataeye/c/r;->a(Lcom/dataeye/b/f;Landroid/database/sqlite/SQLiteDatabase;)V

    goto :goto_0

    :cond_5
    :try_start_1
    const-string v0, "_dc_oss_def_mobi"
    :try_end_1
    .catch Ljava/lang/Throwable; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_2

    :catch_0
    move-exception v0

    move-object v9, v0

    :try_start_2
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    sub-long v3, v0, v10

    if-eqz v12, :cond_6

    const-string v0, "_dc_oss_def_wifi"

    :goto_3
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "upload:"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v9}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const/4 v2, 0x0

    invoke-virtual {p0}, Lcom/dataeye/a/e;->a()[B

    move-result-object v5

    array-length v5, v5

    int-to-long v5, v5

    sget-object v7, Lcom/dataeye/c/b;->l:Ljava/lang/String;

    invoke-static/range {v0 .. v7}, Lcom/dataeye/c/v;->a(Ljava/lang/String;Ljava/lang/String;ZJJLjava/lang/String;)V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    const/4 v0, 0x0

    :try_start_3
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "Invoke CacheFactory.doUpload error, reason:"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v9}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1, v9}, Lcom/dataeye/c/t;->a(Ljava/lang/String;Ljava/lang/Throwable;)V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    invoke-static {}, Lcom/dataeye/c/r;->a()Lcom/dataeye/c/r;

    move-result-object v1

    invoke-virtual {v1, p0, p1}, Lcom/dataeye/c/r;->a(Lcom/dataeye/b/f;Landroid/database/sqlite/SQLiteDatabase;)V

    goto/16 :goto_0

    :cond_6
    :try_start_4
    const-string v0, "_dc_oss_def_mobi"
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    goto :goto_3

    :catchall_0
    move-exception v0

    :goto_4
    if-nez v8, :cond_7

    invoke-static {}, Lcom/dataeye/c/r;->a()Lcom/dataeye/c/r;

    move-result-object v1

    invoke-virtual {v1, p0, p1}, Lcom/dataeye/c/r;->a(Lcom/dataeye/b/f;Landroid/database/sqlite/SQLiteDatabase;)V

    :cond_7
    throw v0

    :catchall_1
    move-exception v1

    move v8, v0

    move-object v0, v1

    goto :goto_4
.end method

.method public static b(I)J
    .locals 8

    const-wide/16 v6, 0x0

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "DC_SPENDTIMEINLEVELS_"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0, v6, v7}, Lcom/dataeye/c/y;->a(Ljava/lang/String;J)J

    move-result-wide v0

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    sget-wide v4, Lcom/dataeye/c/b;->f:J

    sub-long/2addr v2, v4

    cmp-long v4, v2, v6

    if-lez v4, :cond_0

    add-long/2addr v0, v2

    :cond_0
    return-wide v0
.end method

.method public static b()V
    .locals 2

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    sput-wide v0, Lcom/dataeye/c/b;->e:J

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    sput-wide v0, Lcom/dataeye/c/b;->d:J

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    sput-wide v0, Lcom/dataeye/c/b;->f:J

    sget-wide v0, Lcom/dataeye/c/b;->d:J

    sput-wide v0, Lcom/dataeye/c/b;->g:J

    return-void
.end method

.method public static b(Landroid/content/Context;)V
    .locals 4

    const-string v0, "Invoke CacheFactory.uploadHistoryDataWhenNetworkChange start [N]"

    invoke-static {v0}, Lcom/dataeye/c/t;->a(Ljava/lang/String;)V

    const/4 v1, 0x0

    :try_start_0
    sget-object v0, Lcom/dataeye/c/w;->c:Ljava/lang/String;

    invoke-static {p0, v0}, Lcom/dataeye/c/r;->a(Landroid/content/Context;Ljava/lang/String;)V

    invoke-static {}, Lcom/dataeye/c/r;->c()Lcom/dataeye/c/q;

    move-result-object v0

    invoke-virtual {v0}, Lcom/dataeye/c/q;->a()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v1

    invoke-static {p0, v1}, Lcom/dataeye/c/b;->a(Landroid/content/Context;Landroid/database/sqlite/SQLiteDatabase;)Z

    invoke-static {}, Lcom/dataeye/c/r;->c()Lcom/dataeye/c/q;

    move-result-object v0

    invoke-virtual {v0, v1}, Lcom/dataeye/c/q;->a(Landroid/database/sqlite/SQLiteDatabase;)V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz v1, :cond_0

    :try_start_1
    invoke-static {}, Lcom/dataeye/c/r;->c()Lcom/dataeye/c/q;

    move-result-object v0

    invoke-virtual {v0, v1}, Lcom/dataeye/c/q;->a(Landroid/database/sqlite/SQLiteDatabase;)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_3

    :cond_0
    :goto_0
    return-void

    :catch_0
    move-exception v0

    :try_start_2
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "DataEye SDK upload data error(N) , reason"

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2, v0}, Lcom/dataeye/c/t;->a(Ljava/lang/String;Ljava/lang/Throwable;)V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    if-eqz v1, :cond_0

    :try_start_3
    invoke-static {}, Lcom/dataeye/c/r;->c()Lcom/dataeye/c/q;

    move-result-object v0

    invoke-virtual {v0, v1}, Lcom/dataeye/c/q;->a(Landroid/database/sqlite/SQLiteDatabase;)V
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_1

    goto :goto_0

    :catch_1
    move-exception v0

    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_0

    :catchall_0
    move-exception v0

    if-eqz v1, :cond_1

    :try_start_4
    invoke-static {}, Lcom/dataeye/c/r;->c()Lcom/dataeye/c/q;

    move-result-object v2

    invoke-virtual {v2, v1}, Lcom/dataeye/c/q;->a(Landroid/database/sqlite/SQLiteDatabase;)V
    :try_end_4
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_2

    :cond_1
    :goto_1
    throw v0

    :catch_2
    move-exception v1

    invoke-virtual {v1}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_1

    :catch_3
    move-exception v0

    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_0
.end method

.method public static b(Lcom/dataeye/a/a;J)V
    .locals 3

    if-nez p0, :cond_0

    const-string v0, "Invoke addDCSyncInHistoryAndUploadAsync fail , reason oldAccountInfo is null"

    invoke-static {v0}, Lcom/dataeye/c/t;->a(Ljava/lang/String;)V

    :goto_0
    return-void

    :cond_0
    :try_start_0
    new-instance v0, Lcom/dataeye/c/d;

    invoke-direct {v0, p0, p1, p2}, Lcom/dataeye/c/d;-><init>(Lcom/dataeye/a/a;J)V

    invoke-static {v0}, Lcom/dataeye/c/h;->b(Lcom/dataeye/c/k;)V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :goto_1
    const-string v0, "Invoke addDCSyncInHistoryAndUploadAsync finish"

    invoke-static {v0}, Lcom/dataeye/c/t;->a(Ljava/lang/String;)V

    goto :goto_0

    :catch_0
    move-exception v0

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "Invoke addDCSyncInHistoryAndUploadAsync error, reason:"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1, v0}, Lcom/dataeye/c/t;->a(Ljava/lang/String;Ljava/lang/Throwable;)V

    goto :goto_1
.end method

.method public static b(Lcom/dataeye/a/h;)V
    .locals 2

    invoke-static {}, Lcom/dataeye/c/r;->a()Lcom/dataeye/c/r;

    move-result-object v0

    const-string v1, "NoLoginAccoundId"

    invoke-virtual {v0, v1, p0}, Lcom/dataeye/c/r;->b(Ljava/lang/String;Lcom/dataeye/a/h;)V

    return-void
.end method

.method public static b(Ljava/lang/String;Lcom/dataeye/a/h;)V
    .locals 4

    const-string v0, ""

    invoke-static {p0, v0}, Lcom/dataeye/c/y;->a(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_0

    :goto_0
    return-void

    :cond_0
    new-instance v1, Lcom/dataeye/a/h;

    invoke-direct {v1}, Lcom/dataeye/a/h;-><init>()V

    :try_start_0
    new-instance v2, Lcom/dataeye/b/c;

    invoke-static {v0}, Lcom/dataeye/b/a;->a(Ljava/lang/String;)[B

    move-result-object v0

    invoke-direct {v2, v0}, Lcom/dataeye/b/c;-><init>([B)V

    invoke-virtual {v1, v2}, Lcom/dataeye/a/h;->a(Lcom/dataeye/b/c;)V

    iget v0, v1, Lcom/dataeye/a/h;->e:I

    if-lez v0, :cond_5

    invoke-static {}, Lcom/dataeye/c/ab;->b()I

    move-result v0

    iget v2, v1, Lcom/dataeye/a/h;->e:I

    sub-int/2addr v0, v2

    int-to-long v2, v0

    iput-wide v2, p1, Lcom/dataeye/a/h;->b:J

    iget-object v0, v1, Lcom/dataeye/a/h;->c:Ljava/util/Map;

    if-nez v0, :cond_1

    iget-object v0, p1, Lcom/dataeye/a/h;->c:Ljava/util/Map;

    if-eqz v0, :cond_4

    :cond_1
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    iget-object v2, v1, Lcom/dataeye/a/h;->c:Ljava/util/Map;

    if-eqz v2, :cond_2

    iget-object v2, v1, Lcom/dataeye/a/h;->c:Ljava/util/Map;

    invoke-interface {v0, v2}, Ljava/util/Map;->putAll(Ljava/util/Map;)V

    :cond_2
    iget-object v2, p1, Lcom/dataeye/a/h;->c:Ljava/util/Map;

    if-eqz v2, :cond_3

    iget-object v2, p1, Lcom/dataeye/a/h;->c:Ljava/util/Map;

    invoke-interface {v0, v2}, Ljava/util/Map;->putAll(Ljava/util/Map;)V

    :cond_3
    iput-object v0, p1, Lcom/dataeye/a/h;->c:Ljava/util/Map;

    :cond_4
    iget v0, v1, Lcom/dataeye/a/h;->e:I

    iput v0, p1, Lcom/dataeye/a/h;->e:I

    invoke-static {}, Lcom/dataeye/c/ab;->b()I

    move-result v0

    iput v0, p1, Lcom/dataeye/a/h;->f:I

    :cond_5
    invoke-static {p1}, Lcom/dataeye/c/b;->a(Lcom/dataeye/a/h;)V

    invoke-static {p0}, Lcom/dataeye/c/y;->a(Ljava/lang/String;)Z
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    goto :goto_0
.end method

.method public static b(Landroid/database/sqlite/SQLiteDatabase;)Z
    .locals 7

    const/4 v6, 0x0

    :try_start_0
    invoke-static {}, Lcom/dataeye/c/a;->g()Lcom/dataeye/a/a;

    move-result-object v0

    sget-wide v1, Lcom/dataeye/c/b;->d:J

    const/4 v4, 0x0

    const/4 v5, 0x1

    move-object v3, p0

    invoke-static/range {v0 .. v5}, Lcom/dataeye/c/b;->a(Lcom/dataeye/a/a;JLandroid/database/sqlite/SQLiteDatabase;ZZ)Lcom/dataeye/a/e;

    move-result-object v0

    const/4 v1, 0x1

    invoke-static {v0, p0, v1}, Lcom/dataeye/c/b;->a(Lcom/dataeye/a/e;Landroid/database/sqlite/SQLiteDatabase;Z)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v1, "DataEye SDK upload data success!(BL)"

    invoke-static {v1}, Lcom/dataeye/c/t;->b(Ljava/lang/String;)V

    :goto_0
    return v0

    :cond_0
    const-string v1, "DataEye SDK upload data fail!(BL)"

    invoke-static {v1}, Lcom/dataeye/c/t;->b(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "DataEye SDK upload data error(BL) , reason:"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1, v0}, Lcom/dataeye/c/t;->a(Ljava/lang/String;Ljava/lang/Throwable;)V

    move v0, v6

    goto :goto_0
.end method

.method public static c()V
    .locals 2

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    sput-wide v0, Lcom/dataeye/c/b;->d:J

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    sput-wide v0, Lcom/dataeye/c/b;->f:J

    sget-wide v0, Lcom/dataeye/c/b;->d:J

    sput-wide v0, Lcom/dataeye/c/b;->g:J

    return-void
.end method

.method public static c(I)V
    .locals 8

    const-wide/16 v6, 0x0

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "DC_SPENDTIMEINLEVELS_"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0, v6, v7}, Lcom/dataeye/c/y;->a(Ljava/lang/String;J)J

    move-result-wide v0

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    sget-wide v4, Lcom/dataeye/c/b;->f:J

    sub-long/2addr v2, v4

    cmp-long v4, v2, v6

    if-lez v4, :cond_0

    add-long/2addr v0, v2

    :cond_0
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "DC_SPENDTIMEINLEVELS_"

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2, v0, v1}, Lcom/dataeye/c/y;->b(Ljava/lang/String;J)V

    return-void
.end method

.method public static final d()V
    .locals 2

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    sput-wide v0, Lcom/dataeye/c/b;->g:J

    invoke-static {}, Lcom/dataeye/c/a;->g()Lcom/dataeye/a/a;

    move-result-object v0

    if-eqz v0, :cond_0

    invoke-static {}, Lcom/dataeye/c/a;->g()Lcom/dataeye/a/a;

    move-result-object v0

    iget v0, v0, Lcom/dataeye/a/a;->g:I

    invoke-static {v0}, Lcom/dataeye/c/b;->c(I)V

    :cond_0
    return-void
.end method

.method public static e()Landroid/content/Context;
    .locals 1

    sget-object v0, Lcom/dataeye/c/b;->o:Landroid/content/Context;

    return-object v0
.end method

.method public static f()I
    .locals 4

    sget-wide v0, Lcom/dataeye/c/b;->d:J

    const-wide/16 v2, 0x3e8

    div-long/2addr v0, v2

    long-to-int v0, v0

    return v0
.end method

.method public static g()I
    .locals 4

    sget-wide v0, Lcom/dataeye/c/b;->e:J

    const-wide/16 v2, 0x3e8

    div-long/2addr v0, v2

    long-to-int v0, v0

    return v0
.end method

.method public static h()V
    .locals 4

    sget-object v0, Lcom/dataeye/c/b;->k:Ljava/util/LinkedList;

    if-eqz v0, :cond_1

    sget-object v0, Lcom/dataeye/c/b;->k:Ljava/util/LinkedList;

    invoke-virtual {v0}, Ljava/util/LinkedList;->clear()V

    :goto_0
    sget-object v0, Lcom/dataeye/c/b;->k:Ljava/util/LinkedList;

    const-string v1, "rd.gdatacube.net"

    invoke-virtual {v0, v1}, Ljava/util/LinkedList;->add(Ljava/lang/Object;)Z

    sget-object v0, Lcom/dataeye/c/b;->k:Ljava/util/LinkedList;

    const-string v1, "rd.de123.net"

    invoke-virtual {v0, v1}, Ljava/util/LinkedList;->add(Ljava/lang/Object;)Z

    :try_start_0
    const-string v0, "DESelf_Key_Hosts"

    const-string v1, ""

    invoke-static {v0, v1}, Lcom/dataeye/DCConfigParams;->getParameterString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "F:"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/dataeye/c/t;->a(Ljava/lang/String;)V

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_0

    new-instance v1, Lorg/json/JSONArray;

    invoke-direct {v1, v0}, Lorg/json/JSONArray;-><init>(Ljava/lang/String;)V

    const/4 v0, 0x0

    :goto_1
    invoke-virtual {v1}, Lorg/json/JSONArray;->length()I
    :try_end_0
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_0

    move-result v2

    if-lt v0, v2, :cond_2

    :cond_0
    :goto_2
    return-void

    :cond_1
    new-instance v0, Ljava/util/LinkedList;

    invoke-direct {v0}, Ljava/util/LinkedList;-><init>()V

    sput-object v0, Lcom/dataeye/c/b;->k:Ljava/util/LinkedList;

    goto :goto_0

    :cond_2
    :try_start_1
    invoke-virtual {v1, v0}, Lorg/json/JSONArray;->getString(I)Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v3

    if-nez v3, :cond_3

    sget-object v3, Lcom/dataeye/c/b;->k:Ljava/util/LinkedList;

    invoke-virtual {v3, v2}, Ljava/util/LinkedList;->add(Ljava/lang/Object;)Z
    :try_end_1
    .catch Lorg/json/JSONException; {:try_start_1 .. :try_end_1} :catch_0

    :cond_3
    add-int/lit8 v0, v0, 0x1

    goto :goto_1

    :catch_0
    move-exception v0

    invoke-virtual {v0}, Lorg/json/JSONException;->printStackTrace()V

    goto :goto_2
.end method

.method public static i()V
    .locals 2

    const-string v0, "DC_CURRENT_HOST"

    const-string v1, "rd.gdatacube.net"

    invoke-static {v0, v1}, Lcom/dataeye/c/y;->c(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/dataeye/c/b;->l:Ljava/lang/String;

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "inovke initCurrentHost , current host =  "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object v1, Lcom/dataeye/c/b;->l:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/dataeye/c/t;->a(Ljava/lang/String;)V

    return-void
.end method

.method public static j()V
    .locals 3

    sget-object v0, Lcom/dataeye/c/b;->l:Ljava/lang/String;

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v0, "rd.gdatacube.net"

    sput-object v0, Lcom/dataeye/c/b;->l:Ljava/lang/String;

    :goto_0
    return-void

    :cond_0
    sget-object v0, Lcom/dataeye/c/b;->k:Ljava/util/LinkedList;

    invoke-virtual {v0}, Ljava/util/LinkedList;->size()I

    move-result v0

    if-nez v0, :cond_1

    const-string v0, "rd.gdatacube.net"

    sput-object v0, Lcom/dataeye/c/b;->l:Ljava/lang/String;

    invoke-static {}, Lcom/dataeye/c/b;->h()V

    goto :goto_0

    :cond_1
    sget-object v1, Lcom/dataeye/c/b;->k:Ljava/util/LinkedList;

    sget-object v2, Lcom/dataeye/c/b;->l:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/util/LinkedList;->contains(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_2

    const-string v0, "rd.gdatacube.net"

    sput-object v0, Lcom/dataeye/c/b;->l:Ljava/lang/String;

    goto :goto_0

    :cond_2
    sget-object v1, Lcom/dataeye/c/b;->k:Ljava/util/LinkedList;

    sget-object v2, Lcom/dataeye/c/b;->l:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/util/LinkedList;->indexOf(Ljava/lang/Object;)I

    move-result v1

    add-int/lit8 v2, v1, 0x1

    add-int/lit8 v0, v0, -0x1

    if-le v2, v0, :cond_3

    const/4 v0, 0x0

    :goto_1
    sget-object v1, Lcom/dataeye/c/b;->k:Ljava/util/LinkedList;

    invoke-virtual {v1, v0}, Ljava/util/LinkedList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "inovke switchSyncHost , switch host from "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object v2, Lcom/dataeye/c/b;->l:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " to "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/dataeye/c/t;->a(Ljava/lang/String;)V

    sput-object v0, Lcom/dataeye/c/b;->l:Ljava/lang/String;

    goto :goto_0

    :cond_3
    add-int/lit8 v0, v1, 0x1

    goto :goto_1
.end method

.method public static k()J
    .locals 2

    invoke-static {}, Lcom/dataeye/c/ab;->b()I

    move-result v0

    sget v1, Lcom/dataeye/c/b;->h:I

    sub-int/2addr v0, v1

    int-to-long v0, v0

    return-wide v0
.end method

.method public static l()V
    .locals 4

    const-string v0, "Invoke CacheFactory.uploadHistoryData start [SH]"

    invoke-static {v0}, Lcom/dataeye/c/t;->a(Ljava/lang/String;)V

    const/4 v1, 0x0

    :try_start_0
    invoke-static {}, Lcom/dataeye/c/r;->c()Lcom/dataeye/c/q;

    move-result-object v0

    invoke-virtual {v0}, Lcom/dataeye/c/q;->a()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v1

    invoke-static {v1}, Lcom/dataeye/c/b;->a(Landroid/database/sqlite/SQLiteDatabase;)Z

    invoke-static {}, Lcom/dataeye/c/r;->c()Lcom/dataeye/c/q;

    move-result-object v0

    invoke-virtual {v0, v1}, Lcom/dataeye/c/q;->a(Landroid/database/sqlite/SQLiteDatabase;)V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz v1, :cond_0

    :try_start_1
    invoke-static {}, Lcom/dataeye/c/r;->c()Lcom/dataeye/c/q;

    move-result-object v0

    invoke-virtual {v0, v1}, Lcom/dataeye/c/q;->a(Landroid/database/sqlite/SQLiteDatabase;)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_3

    :cond_0
    :goto_0
    return-void

    :catch_0
    move-exception v0

    :try_start_2
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "DataEye SDK upload data error(SH) , reason:"

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2, v0}, Lcom/dataeye/c/t;->a(Ljava/lang/String;Ljava/lang/Throwable;)V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    if-eqz v1, :cond_0

    :try_start_3
    invoke-static {}, Lcom/dataeye/c/r;->c()Lcom/dataeye/c/q;

    move-result-object v0

    invoke-virtual {v0, v1}, Lcom/dataeye/c/q;->a(Landroid/database/sqlite/SQLiteDatabase;)V
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_1

    goto :goto_0

    :catch_1
    move-exception v0

    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_0

    :catchall_0
    move-exception v0

    if-eqz v1, :cond_1

    :try_start_4
    invoke-static {}, Lcom/dataeye/c/r;->c()Lcom/dataeye/c/q;

    move-result-object v2

    invoke-virtual {v2, v1}, Lcom/dataeye/c/q;->a(Landroid/database/sqlite/SQLiteDatabase;)V
    :try_end_4
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_2

    :cond_1
    :goto_1
    throw v0

    :catch_2
    move-exception v1

    invoke-virtual {v1}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_1

    :catch_3
    move-exception v0

    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_0
.end method

.method public static m()V
    .locals 3

    const-string v0, "Invoke CacheFactory.uploadHistoryDataAsync start [H]"

    invoke-static {v0}, Lcom/dataeye/c/t;->a(Ljava/lang/String;)V

    :try_start_0
    new-instance v0, Lcom/dataeye/c/f;

    invoke-direct {v0}, Lcom/dataeye/c/f;-><init>()V

    invoke-static {v0}, Lcom/dataeye/c/h;->a(Lcom/dataeye/c/k;)V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :goto_0
    return-void

    :catch_0
    move-exception v0

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "DataEye SDK upload data error(H) , reason"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1, v0}, Lcom/dataeye/c/t;->a(Ljava/lang/String;Ljava/lang/Throwable;)V

    goto :goto_0
.end method

.method public static n()V
    .locals 3

    const-string v0, "Invoke CacheFactory.uploadBeforeLoginEventAsync start [BL]"

    invoke-static {v0}, Lcom/dataeye/c/t;->a(Ljava/lang/String;)V

    :try_start_0
    new-instance v0, Lcom/dataeye/c/g;

    invoke-direct {v0}, Lcom/dataeye/c/g;-><init>()V

    invoke-static {v0}, Lcom/dataeye/c/h;->a(Lcom/dataeye/c/k;)V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :goto_0
    return-void

    :catch_0
    move-exception v0

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "DataEye SDK upload data error(BL) , reason"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1, v0}, Lcom/dataeye/c/t;->a(Ljava/lang/String;Ljava/lang/Throwable;)V

    goto :goto_0
.end method

.method private static o()V
    .locals 9

    const/4 v8, 0x4

    const/4 v7, 0x3

    const/4 v6, 0x2

    const/4 v5, 0x1

    const/4 v4, 0x0

    const-string v0, "DC_JPush_Registed"

    const-string v1, ""

    invoke-static {v0, v1}, Lcom/dataeye/c/y;->c(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_1

    const-string v1, "@@"

    invoke-virtual {v0, v1}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    array-length v1, v0

    if-ne v1, v8, :cond_0

    new-instance v1, Ljava/util/HashMap;

    invoke-direct {v1}, Ljava/util/HashMap;-><init>()V

    const-string v2, "uid"

    aget-object v3, v0, v4

    invoke-virtual {v1, v2, v3}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v2, "appid"

    aget-object v3, v0, v5

    invoke-virtual {v1, v2, v3}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v2, "token"

    aget-object v3, v0, v6

    invoke-virtual {v1, v2, v3}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v2, "registeTime"

    aget-object v0, v0, v7

    invoke-virtual {v1, v2, v0}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v0, "_DESelf_JPush_Registed"

    invoke-static {v0, v1}, Lcom/dataeye/DCEvent;->onEvent(Ljava/lang/String;Ljava/util/Map;)V

    :cond_0
    const-string v0, "DC_JPush_Registed"

    invoke-static {v0}, Lcom/dataeye/c/y;->b(Ljava/lang/String;)Z

    :cond_1
    const-string v0, "DC_XinGe_Registed"

    const-string v1, ""

    invoke-static {v0, v1}, Lcom/dataeye/c/y;->c(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_3

    const-string v1, "@@"

    invoke-virtual {v0, v1}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    array-length v1, v0

    if-ne v1, v8, :cond_2

    new-instance v1, Ljava/util/HashMap;

    invoke-direct {v1}, Ljava/util/HashMap;-><init>()V

    const-string v2, "uid"

    aget-object v3, v0, v4

    invoke-virtual {v1, v2, v3}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v2, "appid"

    aget-object v3, v0, v5

    invoke-virtual {v1, v2, v3}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v2, "token"

    aget-object v3, v0, v6

    invoke-virtual {v1, v2, v3}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v2, "registeTime"

    aget-object v0, v0, v7

    invoke-virtual {v1, v2, v0}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v0, "_DESelf_XinGe_Registed"

    invoke-static {v0, v1}, Lcom/dataeye/DCEvent;->onEvent(Ljava/lang/String;Ljava/util/Map;)V

    :cond_2
    const-string v0, "DC_XinGe_Registed"

    invoke-static {v0}, Lcom/dataeye/c/y;->b(Ljava/lang/String;)Z

    :cond_3
    return-void
.end method
