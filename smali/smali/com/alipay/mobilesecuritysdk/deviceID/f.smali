.class public final Lcom/alipay/mobilesecuritysdk/deviceID/f;
.super Ljava/lang/Object;


# static fields
.field public static final A:Ljava/lang/String; = "rule"

.field public static final B:Ljava/lang/String; = "checkcode"

.field public static final a:Ljava/lang/String; = "profiles"

.field public static final b:Ljava/lang/String; = "deviceid"

.field public static final c:Ljava/lang/String; = "deviceFingerprint"

.field public static final d:Ljava/lang/String; = "1"

.field public static final e:Ljava/lang/String; = "AH1"

.field public static final f:Ljava/lang/String; = "AH2"

.field public static final g:Ljava/lang/String; = "AH3"

.field public static final h:Ljava/lang/String; = "AH4"

.field public static final i:Ljava/lang/String; = "AH5"

.field public static final j:Ljava/lang/String; = "AH6"

.field public static final k:Ljava/lang/String; = "AH7"

.field public static final l:Ljava/lang/String; = "AH8"

.field public static final m:Ljava/lang/String; = "AH9"

.field public static final n:Ljava/lang/String; = "AH10"

.field public static final o:Ljava/lang/String; = "AS1"

.field public static final p:Ljava/lang/String; = "AS2"

.field public static final q:Ljava/lang/String; = "AS3"

.field public static final r:Ljava/lang/String; = "AS4"

.field public static final s:Ljava/lang/String; = "AC1"

.field public static final t:Ljava/lang/String; = "AC2"

.field public static final u:Ljava/lang/String; = "appId"

.field public static final v:Ljava/lang/String; = "deviceInfo"

.field public static final w:Ljava/lang/String; = "deviceId"

.field public static final x:Ljava/lang/String; = "priDeviceId"

.field public static final y:Ljava/lang/String; = "time"

.field public static final z:Ljava/lang/String; = "apdtk"


# instance fields
.field C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

.field private D:Lcom/alipay/mobilesecuritysdk/deviceID/j;


# direct methods
.method public constructor <init>()V
    .locals 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    new-instance v0, Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-direct {v0}, Lcom/alipay/mobilesecuritysdk/deviceID/g;-><init>()V

    iput-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    new-instance v0, Lcom/alipay/mobilesecuritysdk/deviceID/j;

    invoke-direct {v0}, Lcom/alipay/mobilesecuritysdk/deviceID/j;-><init>()V

    iput-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->D:Lcom/alipay/mobilesecuritysdk/deviceID/j;

    return-void
.end method

.method private a(Landroid/content/Context;Ljava/lang/String;)V
    .locals 3

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/k;->a()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0, p2}, Lcom/alipay/mobilesecuritysdk/deviceID/k;->a(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_0

    :goto_0
    return-void

    :cond_0
    new-instance v1, Ljava/util/HashMap;

    invoke-direct {v1}, Ljava/util/HashMap;-><init>()V

    const-string v2, "deviceid"

    invoke-interface {v1, v2, v0}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->D:Lcom/alipay/mobilesecuritysdk/deviceID/j;

    const-string v0, "profiles"

    const/4 v2, 0x0

    invoke-virtual {p1, v0, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-static {v0, v1}, Lcom/alipay/mobilesecuritysdk/deviceID/j;->a(Landroid/content/SharedPreferences;Ljava/util/Map;)V

    goto :goto_0
.end method

.method private a(Landroid/content/Context;Ljava/util/Map;)V
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Ljava/util/Map",
            "<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    const/16 v3, 0x20

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->a()Lcom/alipay/mobilesecuritysdk/deviceID/a;

    invoke-static {p1}, Lcom/alipay/mobilesecuritysdk/deviceID/i;->a(Landroid/content/Context;)V

    if-eqz p2, :cond_1

    :try_start_0
    invoke-interface {p2}, Ljava/util/Map;->size()I

    move-result v0

    if-lez v0, :cond_1

    const-string v0, "tid"

    invoke-interface {p2, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_0

    iget-object v1, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    const-string v0, "tid"

    invoke-interface {p2, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-virtual {v1, v0}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->e(Ljava/lang/String;)V

    :cond_0
    const-string v0, "utdid"

    invoke-interface {p2, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_1

    iget-object v1, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    const-string v0, "utdid"

    invoke-interface {p2, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-virtual {v1, v0}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->f(Ljava/lang/String;)V

    :cond_1
    invoke-static {p1}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->b(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_2

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-static {p1}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->b(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->g(Ljava/lang/String;)V

    :cond_2
    invoke-static {p1}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->c(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_3

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-static {p1}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->c(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->h(Ljava/lang/String;)V

    :cond_3
    invoke-static {p1}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->a(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_4

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-static {p1}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->a(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->i(Ljava/lang/String;)V

    :cond_4
    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->f()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_5

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->f()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->j(Ljava/lang/String;)V

    :cond_5
    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->b()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_6

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->b()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->k(Ljava/lang/String;)V

    :cond_6
    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->j()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_7

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->j()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->l(Ljava/lang/String;)V

    :cond_7
    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->g()J

    move-result-wide v0

    invoke-static {v0, v1}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_8

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->g()J

    move-result-wide v1

    invoke-static {v1, v2}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->m(Ljava/lang/String;)V

    :cond_8
    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->h()J

    move-result-wide v0

    invoke-static {v0, v1}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_9

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->h()J

    move-result-wide v1

    invoke-static {v1, v2}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->n(Ljava/lang/String;)V

    :cond_9
    invoke-static {p1}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->d(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_a

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-static {p1}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->d(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->o(Ljava/lang/String;)V

    :cond_a
    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->e()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_b

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->e()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->p(Ljava/lang/String;)V

    :cond_b
    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->i()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_c

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->i()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->s(Ljava/lang/String;)V

    :cond_c
    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->c()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_d

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->c()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->t(Ljava/lang/String;)V

    :cond_d
    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->k()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_e

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->k()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->u(Ljava/lang/String;)V

    :cond_e
    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->d()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_f

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->d()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->v(Ljava/lang/String;)V

    :cond_f
    invoke-static {p1}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->e(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_10

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-static {p1}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->e(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->a(Ljava/lang/String;)V

    :cond_10
    invoke-virtual {p0, p1}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->a(Landroid/content/Context;)Ljava/util/Map;

    move-result-object v1

    if-eqz v1, :cond_14

    invoke-interface {v1}, Ljava/util/Map;->size()I

    move-result v0

    if-lez v0, :cond_14

    const-string v0, "apdtk"

    invoke-interface {v1, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_11

    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    const-string v0, "apdtk"

    invoke-interface {v1, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-virtual {v2, v0}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->r(Ljava/lang/String;)V

    :cond_11
    const-string v0, "deviceId"

    invoke-interface {v1, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_12

    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    const-string v0, "deviceId"

    invoke-interface {v1, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-virtual {v2, v0}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->c(Ljava/lang/String;)V

    :cond_12
    const-string v0, "time"

    invoke-interface {v1, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_13

    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    const-string v0, "time"

    invoke-interface {v1, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-virtual {v2, v0}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->q(Ljava/lang/String;)V

    :cond_13
    const-string v0, "rule"

    invoke-interface {v1, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_14

    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    const-string v0, "rule"

    invoke-interface {v1, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-virtual {v2, v0}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->d(Ljava/lang/String;)V

    :cond_14
    invoke-virtual {p0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->a()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_16

    invoke-virtual {p0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->a()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v0

    if-le v0, v3, :cond_16

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {p0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->a()Ljava/lang/String;

    move-result-object v1

    const/4 v2, 0x0

    const/16 v3, 0x20

    invoke-virtual {v1, v2, v3}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->b(Ljava/lang/String;)V

    :cond_15
    :goto_0
    return-void

    :cond_16
    invoke-virtual {p0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->b()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_15

    invoke-virtual {p0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->b()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v0

    if-le v0, v3, :cond_15

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {p0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->b()Ljava/lang/String;

    move-result-object v1

    const/4 v2, 0x0

    const/16 v3, 0x20

    invoke-virtual {v1, v2, v3}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->b(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/deviceID/i;->a(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->c(Ljava/lang/String;)V

    goto :goto_0
.end method

.method private static a(Ljava/lang/String;Ljava/lang/String;)Z
    .locals 1

    if-eqz p0, :cond_0

    if-nez p1, :cond_1

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0

    :cond_1
    invoke-virtual {p0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    goto :goto_0
.end method

.method public static a(Ljava/util/Map;)Z
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Map",
            "<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;)Z"
        }
    .end annotation

    const/4 v0, 0x0

    if-eqz p0, :cond_0

    invoke-interface {p0}, Ljava/util/Map;->size()I

    move-result v1

    if-gez v1, :cond_1

    :cond_0
    :goto_0
    return v0

    :cond_1
    const-string v1, "deviceId"

    invoke-interface {p0, v1}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    const-string v1, "checkcode"

    invoke-interface {p0, v1}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    const-string v1, "apdtk"

    invoke-interface {p0, v1}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    const-string v1, "time"

    invoke-interface {p0, v1}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    const-string v1, "rule"

    invoke-interface {p0, v1}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    const/4 v0, 0x1

    goto :goto_0
.end method

.method private b(Landroid/content/Context;Ljava/util/Map;)Ljava/lang/String;
    .locals 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Ljava/util/Map",
            "<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;)",
            "Ljava/lang/String;"
        }
    .end annotation

    const/16 v6, 0x20

    const/4 v0, 0x1

    const/4 v1, 0x0

    if-nez p2, :cond_0

    invoke-virtual {p0, p1}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->b(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    :goto_0
    return-object v0

    :cond_0
    invoke-virtual {p0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->a()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_5

    invoke-virtual {p0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->a()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v2

    if-lez v2, :cond_5

    move v2, v0

    :goto_1
    if-eqz v2, :cond_7

    invoke-virtual {p0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->b()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_6

    invoke-virtual {p0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->b()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v2

    if-lez v2, :cond_6

    move v2, v0

    :goto_2
    if-eqz v2, :cond_7

    :goto_3
    invoke-static {p2}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->a(Ljava/util/Map;)Z

    move-result v2

    if-eqz v2, :cond_b

    if-nez v0, :cond_1

    const-string v0, "priDeviceId"

    invoke-interface {p2, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_1

    const-string v0, "time"

    invoke-interface {p2, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_1

    new-instance v2, Ljava/lang/StringBuilder;

    const-string v0, "priDeviceId"

    invoke-interface {p2, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v2, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v0, "time"

    invoke-interface {p2, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->a(Ljava/lang/String;)V

    invoke-virtual {p0, v0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->b(Ljava/lang/String;)V

    :cond_1
    const-string v0, "checkcode"

    invoke-interface {p2, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-virtual {p0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->c()Ljava/lang/String;

    move-result-object v2

    if-nez v2, :cond_2

    const-string v2, ""

    :cond_2
    invoke-static {v2}, Lcom/alipay/mobilesecuritysdk/util/a;->c(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    if-nez v2, :cond_3

    const-string v2, ""

    :cond_3
    invoke-virtual {p0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->a()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {p0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->b()Ljava/lang/String;

    move-result-object v4

    invoke-static {v3}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v5

    if-nez v5, :cond_8

    iget-object v4, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->c()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v1, v6}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v4, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    :goto_4
    if-eqz v3, :cond_b

    if-eqz v0, :cond_4

    if-nez v2, :cond_a

    :cond_4
    :goto_5
    if-eqz v1, :cond_b

    const-string v0, "apdid"

    invoke-interface {p2, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    goto/16 :goto_0

    :cond_5
    move v2, v1

    goto/16 :goto_1

    :cond_6
    move v2, v1

    goto/16 :goto_2

    :cond_7
    move v0, v1

    goto/16 :goto_3

    :cond_8
    invoke-static {v4}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_9

    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->c()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v4, v1, v6}, Ljava/lang/String;->subSequence(II)Ljava/lang/CharSequence;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    goto :goto_4

    :cond_9
    move v3, v1

    goto :goto_4

    :cond_a
    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    goto :goto_5

    :cond_b
    invoke-virtual {p0, p1}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->b(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_0
.end method

.method private d()Ljava/util/Map;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/Map",
            "<",
            "Ljava/lang/String;",
            "Ljava/lang/Object;",
            ">;"
        }
    .end annotation

    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    new-instance v1, Ljava/util/HashMap;

    invoke-direct {v1}, Ljava/util/HashMap;-><init>()V

    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->g()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_5

    const-string v2, "AH1"

    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->g()Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_0
    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->h()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_6

    const-string v2, "AH2"

    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->h()Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_1
    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->i()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_7

    const-string v2, "AH3"

    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->i()Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_2
    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->j()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_8

    const-string v2, "AH4"

    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->j()Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_3
    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->k()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_9

    const-string v2, "AH5"

    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->k()Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_4
    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->l()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_a

    const-string v2, "AH6"

    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->l()Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_5
    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->m()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_b

    const-string v2, "AH7"

    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->m()Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_6
    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->n()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_c

    const-string v2, "AH8"

    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->n()Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_7
    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->o()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_d

    const-string v2, "AH9"

    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->o()Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_8
    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->p()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_e

    const-string v2, "AH10"

    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->p()Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_9
    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->s()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_f

    const-string v2, "AS1"

    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->s()Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_a
    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->t()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_10

    const-string v2, "AS2"

    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->t()Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_b
    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->u()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_11

    const-string v2, "AS3"

    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->u()Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_c
    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->v()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_12

    const-string v2, "AS4"

    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->v()Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_d
    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->e()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_13

    const-string v2, "AC1"

    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->e()Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_e
    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->f()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_14

    const-string v2, "AC2"

    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->f()Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_f
    const-string v2, "deviceInfo"

    invoke-interface {v0, v2, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    iget-object v1, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v1}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->b()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_0

    const-string v1, "deviceId"

    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->b()Ljava/lang/String;

    move-result-object v2

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_0
    iget-object v1, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v1}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->c()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_1

    const-string v1, "priDeviceId"

    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->c()Ljava/lang/String;

    move-result-object v2

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_1
    iget-object v1, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v1}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->a()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_2

    const-string v1, "appId"

    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->a()Ljava/lang/String;

    move-result-object v2

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_2
    iget-object v1, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v1}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->q()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_3

    const-string v1, "time"

    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->q()Ljava/lang/String;

    move-result-object v2

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_3
    iget-object v1, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v1}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->r()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_4

    const-string v1, "apdtk"

    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->r()Ljava/lang/String;

    move-result-object v2

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_4
    return-object v0

    :cond_5
    const-string v2, "AH1"

    const-string v3, ""

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_0

    :cond_6
    const-string v2, "AH2"

    const-string v3, ""

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_1

    :cond_7
    const-string v2, "AH3"

    const-string v3, ""

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_2

    :cond_8
    const-string v2, "AH4"

    const-string v3, ""

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_3

    :cond_9
    const-string v2, "AH4"

    const-string v3, ""

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_4

    :cond_a
    const-string v2, "AH6"

    const-string v3, ""

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_5

    :cond_b
    const-string v2, "AH7"

    const-string v3, ""

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_6

    :cond_c
    const-string v2, "AH8"

    const-string v3, ""

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_7

    :cond_d
    const-string v2, "AH9"

    const-string v3, ""

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_8

    :cond_e
    const-string v2, "AH10"

    const-string v3, ""

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_9

    :cond_f
    const-string v2, "AS1"

    const-string v3, ""

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_a

    :cond_10
    const-string v2, "AS2"

    const-string v3, ""

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_b

    :cond_11
    const-string v2, "AS3"

    const-string v3, ""

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_c

    :cond_12
    const-string v2, "AS4"

    const-string v3, ""

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_d

    :cond_13
    const-string v2, "AC1"

    const-string v3, ""

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_e

    :cond_14
    const-string v2, "AC2"

    const-string v3, ""

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_f
.end method

.method private e()Ljava/util/Map;
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/Map",
            "<",
            "Ljava/lang/String;",
            "Ljava/lang/Object;",
            ">;"
        }
    .end annotation

    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    const-string v1, "deviceId"

    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->b()Ljava/lang/String;

    move-result-object v2

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v1, "priDeviceId"

    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->c()Ljava/lang/String;

    move-result-object v2

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v1, "appId"

    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->a()Ljava/lang/String;

    move-result-object v2

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v1, "time"

    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->q()Ljava/lang/String;

    move-result-object v2

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v1, "apdtk"

    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->r()Ljava/lang/String;

    move-result-object v2

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    return-object v0
.end method

.method private static f()Ljava/util/Map;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/Map",
            "<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    const/4 v0, 0x0

    return-object v0
.end method

.method private g()Z
    .locals 3

    const/4 v0, 0x1

    const/4 v1, 0x0

    invoke-virtual {p0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->a()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_0

    invoke-virtual {p0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->a()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v2

    if-lez v2, :cond_0

    move v2, v0

    :goto_0
    if-eqz v2, :cond_2

    invoke-virtual {p0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->b()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_1

    invoke-virtual {p0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->b()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v2

    if-lez v2, :cond_1

    move v2, v0

    :goto_1
    if-eqz v2, :cond_2

    :goto_2
    return v0

    :cond_0
    move v2, v1

    goto :goto_0

    :cond_1
    move v2, v1

    goto :goto_1

    :cond_2
    move v0, v1

    goto :goto_2
.end method

.method private h()Z
    .locals 2

    const/4 v0, 0x0

    invoke-virtual {p0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->a()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_1

    :cond_0
    :goto_0
    return v0

    :cond_1
    invoke-virtual {p0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->a()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v1

    if-lez v1, :cond_0

    const/4 v0, 0x1

    goto :goto_0
.end method

.method private i()Z
    .locals 2

    const/4 v0, 0x0

    invoke-virtual {p0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->b()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_1

    :cond_0
    :goto_0
    return v0

    :cond_1
    invoke-virtual {p0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->b()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v1

    if-lez v1, :cond_0

    const/4 v0, 0x1

    goto :goto_0
.end method

.method private j()Ljava/lang/String;
    .locals 1

    invoke-virtual {p0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->c()Ljava/lang/String;

    move-result-object v0

    if-nez v0, :cond_0

    const-string v0, ""

    :cond_0
    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->c(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    if-nez v0, :cond_1

    const-string v0, ""

    :cond_1
    return-object v0
.end method

.method private k()Z
    .locals 5

    const/16 v4, 0x20

    const/4 v0, 0x0

    invoke-virtual {p0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->a()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->b()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_1

    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->c()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v0, v4}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    :cond_0
    :goto_0
    return v0

    :cond_1
    invoke-static {v2}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_0

    iget-object v1, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v1}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->c()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v2, v0, v4}, Ljava/lang/String;->subSequence(II)Ljava/lang/CharSequence;

    move-result-object v0

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    goto :goto_0
.end method

.method private l()Lcom/alipay/mobilesecuritysdk/deviceID/h;
    .locals 6

    const/4 v1, 0x0

    new-instance v0, Lcom/alipay/mobilesecuritysdk/deviceID/h;

    invoke-direct {v0}, Lcom/alipay/mobilesecuritysdk/deviceID/h;-><init>()V

    iput-boolean v1, v0, Lcom/alipay/mobilesecuritysdk/deviceID/h;->h:Z

    iget-object v1, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->D:Lcom/alipay/mobilesecuritysdk/deviceID/j;

    new-instance v1, Ljava/util/HashMap;

    invoke-direct {v1}, Ljava/util/HashMap;-><init>()V

    new-instance v2, Ljava/util/HashMap;

    invoke-direct {v2}, Ljava/util/HashMap;-><init>()V

    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->g()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_6

    const-string v3, "AH1"

    iget-object v4, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->g()Ljava/lang/String;

    move-result-object v4

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_0
    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->h()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_7

    const-string v3, "AH2"

    iget-object v4, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->h()Ljava/lang/String;

    move-result-object v4

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_1
    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->i()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_8

    const-string v3, "AH3"

    iget-object v4, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->i()Ljava/lang/String;

    move-result-object v4

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_2
    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->j()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_9

    const-string v3, "AH4"

    iget-object v4, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->j()Ljava/lang/String;

    move-result-object v4

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_3
    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->k()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_a

    const-string v3, "AH5"

    iget-object v4, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->k()Ljava/lang/String;

    move-result-object v4

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_4
    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->l()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_b

    const-string v3, "AH6"

    iget-object v4, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->l()Ljava/lang/String;

    move-result-object v4

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_5
    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->m()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_c

    const-string v3, "AH7"

    iget-object v4, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->m()Ljava/lang/String;

    move-result-object v4

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_6
    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->n()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_d

    const-string v3, "AH8"

    iget-object v4, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->n()Ljava/lang/String;

    move-result-object v4

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_7
    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->o()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_e

    const-string v3, "AH9"

    iget-object v4, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->o()Ljava/lang/String;

    move-result-object v4

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_8
    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->p()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_f

    const-string v3, "AH10"

    iget-object v4, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->p()Ljava/lang/String;

    move-result-object v4

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_9
    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->s()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_10

    const-string v3, "AS1"

    iget-object v4, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->s()Ljava/lang/String;

    move-result-object v4

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_a
    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->t()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_11

    const-string v3, "AS2"

    iget-object v4, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->t()Ljava/lang/String;

    move-result-object v4

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_b
    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->u()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_12

    const-string v3, "AS3"

    iget-object v4, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->u()Ljava/lang/String;

    move-result-object v4

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_c
    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->v()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_13

    const-string v3, "AS4"

    iget-object v4, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->v()Ljava/lang/String;

    move-result-object v4

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_d
    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->e()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_14

    const-string v3, "AC1"

    iget-object v4, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->e()Ljava/lang/String;

    move-result-object v4

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_e
    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->f()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_15

    const-string v3, "AC2"

    iget-object v4, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->f()Ljava/lang/String;

    move-result-object v4

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_f
    const-string v3, "deviceInfo"

    invoke-interface {v1, v3, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->b()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_0

    const-string v2, "deviceId"

    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->b()Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_0
    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->c()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_1

    const-string v2, "priDeviceId"

    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->c()Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_1
    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->a()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_2

    const-string v2, "appId"

    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->a()Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_2
    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->q()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_3

    const-string v2, "time"

    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->q()Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_3
    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->r()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_4

    const-string v2, "apdtk"

    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->r()Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_4
    invoke-static {v1}, Lcom/alipay/mobilesecuritysdk/deviceID/j;->b(Ljava/util/Map;)Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_5

    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v2

    if-gez v2, :cond_16

    :cond_5
    :goto_10
    return-object v0

    :cond_6
    const-string v3, "AH1"

    const-string v4, ""

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_0

    :cond_7
    const-string v3, "AH2"

    const-string v4, ""

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_1

    :cond_8
    const-string v3, "AH3"

    const-string v4, ""

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_2

    :cond_9
    const-string v3, "AH4"

    const-string v4, ""

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_3

    :cond_a
    const-string v3, "AH4"

    const-string v4, ""

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_4

    :cond_b
    const-string v3, "AH6"

    const-string v4, ""

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_5

    :cond_c
    const-string v3, "AH7"

    const-string v4, ""

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_6

    :cond_d
    const-string v3, "AH8"

    const-string v4, ""

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_7

    :cond_e
    const-string v3, "AH9"

    const-string v4, ""

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_8

    :cond_f
    const-string v3, "AH10"

    const-string v4, ""

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_9

    :cond_10
    const-string v3, "AS1"

    const-string v4, ""

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_a

    :cond_11
    const-string v3, "AS2"

    const-string v4, ""

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_b

    :cond_12
    const-string v3, "AS3"

    const-string v4, ""

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_c

    :cond_13
    const-string v3, "AS4"

    const-string v4, ""

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_d

    :cond_14
    const-string v3, "AC1"

    const-string v4, ""

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_e

    :cond_15
    const-string v3, "AC2"

    const-string v4, ""

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_f

    :cond_16
    :try_start_0
    new-instance v2, LHttpUtils/a;

    invoke-direct {v2}, LHttpUtils/a;-><init>()V

    const-string v2, "https://seccliprod.alipay.com/api/do.htm"

    const-string v3, "deviceFingerprint"

    const-string v4, "1"

    const/4 v5, 0x0

    invoke-static {v2, v3, v1, v4, v5}, LHttpUtils/a;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)Lorg/apache/http/HttpResponse;

    move-result-object v1

    if-eqz v1, :cond_17

    invoke-interface {v1}, Lorg/apache/http/HttpResponse;->getStatusLine()Lorg/apache/http/StatusLine;

    move-result-object v2

    invoke-interface {v2}, Lorg/apache/http/StatusLine;->getStatusCode()I

    move-result v2

    const/16 v3, 0xc8

    if-ne v2, v3, :cond_17

    new-instance v2, Lcom/alipay/mobilesecuritysdk/deviceID/j;

    invoke-direct {v2}, Lcom/alipay/mobilesecuritysdk/deviceID/j;-><init>()V

    invoke-interface {v1}, Lorg/apache/http/HttpResponse;->getEntity()Lorg/apache/http/HttpEntity;

    move-result-object v1

    invoke-static {v1}, Lorg/apache/http/util/EntityUtils;->toString(Lorg/apache/http/HttpEntity;)Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/alipay/mobilesecuritysdk/deviceID/j;->a(Ljava/lang/String;)Lcom/alipay/mobilesecuritysdk/deviceID/h;

    move-result-object v0

    goto/16 :goto_10

    :cond_17
    const/4 v1, 0x0

    iput-boolean v1, v0, Lcom/alipay/mobilesecuritysdk/deviceID/h;->h:Z
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    goto/16 :goto_10

    :catch_0
    move-exception v1

    invoke-static {v1}, Lcom/alipay/mobilesecuritysdk/deviceID/i;->a(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->c(Ljava/lang/String;)V

    goto/16 :goto_10
.end method


# virtual methods
.method public final a()Ljava/lang/String;
    .locals 3

    const/4 v1, 0x0

    const-string v0, "deviceid"

    invoke-static {v0}, Ljava/lang/System;->getProperty(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_0

    :try_start_0
    new-instance v2, Lorg/json/JSONObject;

    invoke-direct {v2, v0}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    const-string v0, "device"

    invoke-virtual {v2, v0}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;
    :try_end_0
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v0

    :goto_0
    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_0

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/k;->a()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1, v0}, Lcom/alipay/mobilesecuritysdk/deviceID/k;->b(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    :cond_0
    return-object v1

    :catch_0
    move-exception v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/deviceID/i;->a(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->c(Ljava/lang/String;)V

    move-object v0, v1

    goto :goto_0
.end method

.method public final a(Landroid/content/Context;)Ljava/util/Map;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            ")",
            "Ljava/util/Map",
            "<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    const/4 v0, 0x0

    iget-object v1, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->D:Lcom/alipay/mobilesecuritysdk/deviceID/j;

    const-string v1, "profiles"

    const/4 v2, 0x0

    invoke-virtual {p1, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v1

    const-string v2, "deviceid"

    const-string v3, ""

    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_1

    :cond_0
    :goto_0
    return-object v0

    :cond_1
    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/k;->a()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2, v1}, Lcom/alipay/mobilesecuritysdk/deviceID/k;->b(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_0

    new-instance v0, Lcom/alipay/mobilesecuritysdk/deviceID/j;

    invoke-direct {v0}, Lcom/alipay/mobilesecuritysdk/deviceID/j;-><init>()V

    invoke-static {v1}, Lcom/alipay/mobilesecuritysdk/deviceID/j;->b(Ljava/lang/String;)Ljava/util/Map;

    move-result-object v0

    goto :goto_0
.end method

.method public final a(Ljava/lang/String;)V
    .locals 3

    invoke-static {p1}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_1

    :cond_0
    :goto_0
    return-void

    :cond_1
    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/k;->a()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0, p1}, Lcom/alipay/mobilesecuritysdk/deviceID/k;->a(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_0

    :try_start_0
    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1}, Lorg/json/JSONObject;-><init>()V

    const-string v2, "device"

    invoke-virtual {v1, v2, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string v0, "deviceid"

    invoke-virtual {v1}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Ljava/lang/System;->setProperty(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    :try_end_0
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/deviceID/i;->a(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->c(Ljava/lang/String;)V

    goto :goto_0
.end method

.method public final b()Ljava/lang/String;
    .locals 4

    const/4 v0, 0x0

    :try_start_0
    invoke-static {}, Lcom/alipay/mobilesecuritysdk/util/a;->a()Z

    move-result v1

    if-eqz v1, :cond_1

    new-instance v1, Ljava/io/File;

    invoke-static {}, Landroid/os/Environment;->getExternalStorageDirectory()Ljava/io/File;

    move-result-object v2

    const-string v3, ".SystemConfig"

    invoke-direct {v1, v2, v3}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/io/File;->exists()Z

    move-result v2

    if-nez v2, :cond_0

    invoke-virtual {v1}, Ljava/io/File;->mkdir()Z

    :cond_0
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-direct {v2, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object v1, Ljava/io/File;->separator:Ljava/lang/String;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "data"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/alipay/mobilesecuritysdk/util/a;->d(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_1

    move-result v2

    if-eqz v2, :cond_2

    :cond_1
    :goto_0
    return-object v0

    :cond_2
    :try_start_1
    new-instance v2, Lorg/json/JSONObject;

    invoke-direct {v2, v1}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    const-string v1, "device"

    invoke-virtual {v2, v1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;
    :try_end_1
    .catch Lorg/json/JSONException; {:try_start_1 .. :try_end_1} :catch_0
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    move-result-object v1

    :goto_1
    :try_start_2
    invoke-static {v1}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_1

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/k;->a()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2, v1}, Lcom/alipay/mobilesecuritysdk/deviceID/k;->b(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    goto :goto_0

    :catch_0
    move-exception v1

    invoke-static {v1}, Lcom/alipay/mobilesecuritysdk/deviceID/i;->a(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->c(Ljava/lang/String;)V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_1

    move-object v1, v0

    goto :goto_1

    :catch_1
    move-exception v1

    invoke-static {v1}, Lcom/alipay/mobilesecuritysdk/deviceID/i;->a(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->c(Ljava/lang/String;)V

    goto :goto_0
.end method

.method public final b(Landroid/content/Context;)Ljava/lang/String;
    .locals 5

    invoke-direct {p0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->l()Lcom/alipay/mobilesecuritysdk/deviceID/h;

    move-result-object v0

    if-eqz v0, :cond_0

    :try_start_0
    iget-boolean v1, v0, Lcom/alipay/mobilesecuritysdk/deviceID/h;->h:Z

    if-eqz v1, :cond_0

    new-instance v1, Ljava/lang/StringBuilder;

    iget-object v2, v0, Lcom/alipay/mobilesecuritysdk/deviceID/h;->b:Ljava/lang/String;

    invoke-static {v2}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v2, v0, Lcom/alipay/mobilesecuritysdk/deviceID/h;->e:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    new-instance v2, Ljava/util/HashMap;

    invoke-direct {v2}, Ljava/util/HashMap;-><init>()V

    const-string v3, "deviceId"

    iget-object v4, v0, Lcom/alipay/mobilesecuritysdk/deviceID/h;->b:Ljava/lang/String;

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v3, "priDeviceId"

    iget-object v4, v0, Lcom/alipay/mobilesecuritysdk/deviceID/h;->b:Ljava/lang/String;

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v3, "time"

    iget-object v4, v0, Lcom/alipay/mobilesecuritysdk/deviceID/h;->e:Ljava/lang/String;

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v3, "checkcode"

    iget-object v4, v0, Lcom/alipay/mobilesecuritysdk/deviceID/h;->f:Ljava/lang/String;

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v3, "rule"

    iget-object v4, v0, Lcom/alipay/mobilesecuritysdk/deviceID/h;->d:Ljava/lang/String;

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v3, "apdtk"

    iget-object v4, v0, Lcom/alipay/mobilesecuritysdk/deviceID/h;->c:Ljava/lang/String;

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    new-instance v3, Lcom/alipay/mobilesecuritysdk/deviceID/j;

    invoke-direct {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/j;-><init>()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :try_start_1
    invoke-static {v2}, Lcom/alipay/mobilesecuritysdk/deviceID/j;->a(Ljava/util/Map;)Ljava/lang/String;

    move-result-object v2

    invoke-direct {p0, p1, v2}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->a(Landroid/content/Context;Ljava/lang/String;)V
    :try_end_1
    .catch Lorg/json/JSONException; {:try_start_1 .. :try_end_1} :catch_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    :goto_0
    :try_start_2
    invoke-virtual {p0, v1}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->a(Ljava/lang/String;)V

    invoke-virtual {p0, v1}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->b(Ljava/lang/String;)V

    iget-object v0, v0, Lcom/alipay/mobilesecuritysdk/deviceID/h;->b:Ljava/lang/String;
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_0

    :goto_1
    return-object v0

    :catch_0
    move-exception v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/deviceID/i;->a(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->c(Ljava/lang/String;)V

    :cond_0
    const/4 v0, 0x0

    goto :goto_1

    :catch_1
    move-exception v2

    goto :goto_0
.end method

.method public final b(Ljava/lang/String;)V
    .locals 4

    :try_start_0
    invoke-static {}, Lcom/alipay/mobilesecuritysdk/util/a;->a()Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/k;->a()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0, p1}, Lcom/alipay/mobilesecuritysdk/deviceID/k;->a(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    new-instance v1, Ljava/io/File;

    invoke-static {}, Landroid/os/Environment;->getExternalStorageDirectory()Ljava/io/File;

    move-result-object v2

    const-string v3, ".SystemConfig"

    invoke-direct {v1, v2, v3}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/io/File;->exists()Z

    move-result v2

    if-nez v2, :cond_0

    invoke-virtual {v1}, Ljava/io/File;->mkdir()Z

    :cond_0
    new-instance v2, Lorg/json/JSONObject;

    invoke-direct {v2}, Lorg/json/JSONObject;-><init>()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_1

    :try_start_1
    const-string v3, "device"

    invoke-virtual {v2, v3, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_1
    .catch Lorg/json/JSONException; {:try_start_1 .. :try_end_1} :catch_0
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    :goto_0
    :try_start_2
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object v1, Ljava/io/File;->separator:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "data"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Lcom/alipay/mobilesecuritysdk/util/a;->b(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_2
    .catch Ljava/io/IOException; {:try_start_2 .. :try_end_2} :catch_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_1

    :cond_1
    :goto_1
    return-void

    :catch_0
    move-exception v0

    :try_start_3
    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/deviceID/i;->a(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->c(Ljava/lang/String;)V
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_1

    goto :goto_0

    :catch_1
    move-exception v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/deviceID/i;->a(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->c(Ljava/lang/String;)V

    goto :goto_1

    :catch_2
    move-exception v0

    :try_start_4
    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/deviceID/i;->a(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->c(Ljava/lang/String;)V
    :try_end_4
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_1

    goto :goto_1
.end method

.method final c()Ljava/lang/String;
    .locals 7

    const/4 v1, 0x0

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v0}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->d()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_1

    move-object v0, v1

    :cond_0
    :goto_0
    return-object v0

    :cond_1
    :try_start_0
    new-instance v0, Lorg/json/JSONObject;

    iget-object v2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->d()Ljava/lang/String;

    move-result-object v2

    invoke-direct {v0, v2}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    const-string v2, "params"

    invoke-virtual {v0, v2}, Lorg/json/JSONObject;->getJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v3

    if-nez v3, :cond_2

    move-object v0, v1

    goto :goto_0

    :cond_2
    new-instance v2, Ljava/lang/String;

    invoke-direct {v2}, Ljava/lang/String;-><init>()V

    const/4 v0, 0x0

    move v6, v0

    move-object v0, v2

    move v2, v6

    :goto_1
    invoke-virtual {v3}, Lorg/json/JSONArray;->length()I

    move-result v4

    if-eq v2, v4, :cond_0

    invoke-virtual {v3, v2}, Lorg/json/JSONArray;->getString(I)Ljava/lang/String;

    move-result-object v4

    const-string v5, "AC1"

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_3

    iget-object v4, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->e()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v4

    if-nez v4, :cond_13

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v0}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->e()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :cond_3
    :goto_2
    invoke-virtual {v3, v2}, Lorg/json/JSONArray;->getString(I)Ljava/lang/String;

    move-result-object v4

    const-string v5, "AC2"

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_4

    iget-object v4, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->f()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v4

    if-nez v4, :cond_14

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v0}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->f()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :cond_4
    :goto_3
    invoke-virtual {v3, v2}, Lorg/json/JSONArray;->getString(I)Ljava/lang/String;

    move-result-object v4

    const-string v5, "AH1"

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_5

    iget-object v4, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->g()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v4

    if-nez v4, :cond_15

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v0}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->g()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :cond_5
    :goto_4
    invoke-virtual {v3, v2}, Lorg/json/JSONArray;->getString(I)Ljava/lang/String;

    move-result-object v4

    const-string v5, "AH2"

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_6

    iget-object v4, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->h()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v4

    if-nez v4, :cond_16

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v0}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->h()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :cond_6
    :goto_5
    invoke-virtual {v3, v2}, Lorg/json/JSONArray;->getString(I)Ljava/lang/String;

    move-result-object v4

    const-string v5, "AH3"

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_7

    iget-object v4, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->i()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v4

    if-nez v4, :cond_17

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v0}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->i()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :cond_7
    :goto_6
    invoke-virtual {v3, v2}, Lorg/json/JSONArray;->getString(I)Ljava/lang/String;

    move-result-object v4

    const-string v5, "AH4"

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_8

    iget-object v4, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->j()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v4

    if-nez v4, :cond_18

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v0}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->j()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :cond_8
    :goto_7
    invoke-virtual {v3, v2}, Lorg/json/JSONArray;->getString(I)Ljava/lang/String;

    move-result-object v4

    const-string v5, "AH5"

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_9

    iget-object v4, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->k()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v4

    if-nez v4, :cond_19

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v0}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->k()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :cond_9
    :goto_8
    invoke-virtual {v3, v2}, Lorg/json/JSONArray;->getString(I)Ljava/lang/String;

    move-result-object v4

    const-string v5, "AH6"

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_a

    iget-object v4, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->l()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v4

    if-nez v4, :cond_1a

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v0}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->l()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :cond_a
    :goto_9
    invoke-virtual {v3, v2}, Lorg/json/JSONArray;->getString(I)Ljava/lang/String;

    move-result-object v4

    const-string v5, "AH7"

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_b

    iget-object v4, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->m()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v4

    if-nez v4, :cond_1b

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v0}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->m()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :cond_b
    :goto_a
    invoke-virtual {v3, v2}, Lorg/json/JSONArray;->getString(I)Ljava/lang/String;

    move-result-object v4

    const-string v5, "AH8"

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_c

    iget-object v4, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->n()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v4

    if-nez v4, :cond_1c

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v0}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->n()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :cond_c
    :goto_b
    invoke-virtual {v3, v2}, Lorg/json/JSONArray;->getString(I)Ljava/lang/String;

    move-result-object v4

    const-string v5, "AH9"

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_d

    iget-object v4, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->o()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v4

    if-nez v4, :cond_1d

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v0}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->o()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :cond_d
    :goto_c
    invoke-virtual {v3, v2}, Lorg/json/JSONArray;->getString(I)Ljava/lang/String;

    move-result-object v4

    const-string v5, "AH10"

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_e

    iget-object v4, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->p()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v4

    if-nez v4, :cond_1e

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v0}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->p()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :cond_e
    :goto_d
    invoke-virtual {v3, v2}, Lorg/json/JSONArray;->getString(I)Ljava/lang/String;

    move-result-object v4

    const-string v5, "AS1"

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_f

    iget-object v4, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->s()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v4

    if-nez v4, :cond_1f

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v0}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->s()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :cond_f
    :goto_e
    invoke-virtual {v3, v2}, Lorg/json/JSONArray;->getString(I)Ljava/lang/String;

    move-result-object v4

    const-string v5, "AS2"

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_10

    iget-object v4, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->t()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v4

    if-nez v4, :cond_20

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v0}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->t()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :cond_10
    :goto_f
    invoke-virtual {v3, v2}, Lorg/json/JSONArray;->getString(I)Ljava/lang/String;

    move-result-object v4

    const-string v5, "AS3"

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_11

    iget-object v4, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->u()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v4

    if-nez v4, :cond_21

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v0}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->u()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :cond_11
    :goto_10
    invoke-virtual {v3, v2}, Lorg/json/JSONArray;->getString(I)Ljava/lang/String;

    move-result-object v4

    const-string v5, "AS4"

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_12

    iget-object v4, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->v()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v4

    if-nez v4, :cond_22

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v0}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->v()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :cond_12
    :goto_11
    add-int/lit8 v2, v2, 0x1

    goto/16 :goto_1

    :cond_13
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_2

    :cond_14
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_3

    :cond_15
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_4

    :cond_16
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_5

    :cond_17
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_6

    :cond_18
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_7

    :cond_19
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_8

    :cond_1a
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_9

    :cond_1b
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_a

    :cond_1c
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_b

    :cond_1d
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_c

    :cond_1e
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_d

    :cond_1f
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_e

    :cond_20
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_f

    :cond_21
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_10

    :cond_22
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    :try_end_0
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v0

    goto/16 :goto_11

    :catch_0
    move-exception v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/deviceID/i;->a(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->c(Ljava/lang/String;)V

    move-object v0, v1

    goto/16 :goto_0
.end method

.method final c(Ljava/lang/String;)V
    .locals 4

    const/16 v3, 0x14

    const/4 v2, 0x0

    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iget-object v1, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v1}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->e()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_0

    iget-object v1, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v1}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->e()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1, v2, v3}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :cond_0
    iget-object v1, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v1}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->f()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_1

    iget-object v1, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v1}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->f()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1, v2, v3}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :cond_1
    iget-object v1, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v1}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->a()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_2

    iget-object v1, p0, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v1}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->a()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1, v2, v3}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :cond_2
    invoke-interface {v0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/deviceID/i;->a(Ljava/util/List;)V

    return-void
.end method
