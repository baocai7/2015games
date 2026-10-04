.class final Lcom/alipay/mobilesecuritysdk/deviceID/d;
.super Ljava/lang/Object;

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field final synthetic a:Lcom/alipay/mobilesecuritysdk/deviceID/c;

.field private final synthetic b:Landroid/content/Context;

.field private final synthetic c:Ljava/util/Map;


# direct methods
.method constructor <init>(Lcom/alipay/mobilesecuritysdk/deviceID/c;Landroid/content/Context;Ljava/util/Map;)V
    .locals 0

    iput-object p1, p0, Lcom/alipay/mobilesecuritysdk/deviceID/d;->a:Lcom/alipay/mobilesecuritysdk/deviceID/c;

    iput-object p2, p0, Lcom/alipay/mobilesecuritysdk/deviceID/d;->b:Landroid/content/Context;

    iput-object p3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/d;->c:Ljava/util/Map;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 11

    const/4 v1, 0x1

    const/16 v10, 0x14

    const/16 v7, 0x20

    const/4 v2, 0x0

    :try_start_0
    new-instance v4, Lcom/alipay/mobilesecuritysdk/deviceID/f;

    invoke-direct {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/f;-><init>()V

    iget-object v3, p0, Lcom/alipay/mobilesecuritysdk/deviceID/d;->b:Landroid/content/Context;

    iget-object v5, p0, Lcom/alipay/mobilesecuritysdk/deviceID/d;->c:Ljava/util/Map;

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->a()Lcom/alipay/mobilesecuritysdk/deviceID/a;

    invoke-static {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/i;->a(Landroid/content/Context;)V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_1

    if-eqz v5, :cond_1

    :try_start_1
    invoke-interface {v5}, Ljava/util/Map;->size()I

    move-result v0

    if-lez v0, :cond_1

    const-string v0, "tid"

    invoke-interface {v5, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_0

    iget-object v6, v4, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    const-string v0, "tid"

    invoke-interface {v5, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-virtual {v6, v0}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->e(Ljava/lang/String;)V

    :cond_0
    const-string v0, "utdid"

    invoke-interface {v5, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_1

    iget-object v6, v4, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    const-string v0, "utdid"

    invoke-interface {v5, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-virtual {v6, v0}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->f(Ljava/lang/String;)V

    :cond_1
    invoke-static {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->b(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_2

    iget-object v0, v4, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-static {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->b(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v0, v5}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->g(Ljava/lang/String;)V

    :cond_2
    invoke-static {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->c(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_3

    iget-object v0, v4, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-static {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->c(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v0, v5}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->h(Ljava/lang/String;)V

    :cond_3
    invoke-static {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->a(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_4

    iget-object v0, v4, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-static {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->a(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v0, v5}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->i(Ljava/lang/String;)V

    :cond_4
    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->f()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_5

    iget-object v0, v4, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->f()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v0, v5}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->j(Ljava/lang/String;)V

    :cond_5
    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->b()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_6

    iget-object v0, v4, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->b()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v0, v5}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->k(Ljava/lang/String;)V

    :cond_6
    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->j()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_7

    iget-object v0, v4, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->j()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v0, v5}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->l(Ljava/lang/String;)V

    :cond_7
    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->g()J

    move-result-wide v5

    invoke-static {v5, v6}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_8

    iget-object v0, v4, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->g()J

    move-result-wide v5

    invoke-static {v5, v6}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v0, v5}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->m(Ljava/lang/String;)V

    :cond_8
    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->h()J

    move-result-wide v5

    invoke-static {v5, v6}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_9

    iget-object v0, v4, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->h()J

    move-result-wide v5

    invoke-static {v5, v6}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v0, v5}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->n(Ljava/lang/String;)V

    :cond_9
    invoke-static {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->d(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_a

    iget-object v0, v4, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-static {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->d(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v0, v5}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->o(Ljava/lang/String;)V

    :cond_a
    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->e()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_b

    iget-object v0, v4, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->e()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v0, v5}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->p(Ljava/lang/String;)V

    :cond_b
    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->i()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_c

    iget-object v0, v4, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->i()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v0, v5}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->s(Ljava/lang/String;)V

    :cond_c
    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->c()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_d

    iget-object v0, v4, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->c()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v0, v5}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->t(Ljava/lang/String;)V

    :cond_d
    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->k()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_e

    iget-object v0, v4, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->k()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v0, v5}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->u(Ljava/lang/String;)V

    :cond_e
    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->d()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_f

    iget-object v0, v4, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->d()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v0, v5}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->v(Ljava/lang/String;)V

    :cond_f
    invoke-static {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->e(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_10

    iget-object v0, v4, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-static {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/a;->e(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v0, v5}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->a(Ljava/lang/String;)V

    :cond_10
    invoke-virtual {v4, v3}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->a(Landroid/content/Context;)Ljava/util/Map;

    move-result-object v3

    if-eqz v3, :cond_14

    invoke-interface {v3}, Ljava/util/Map;->size()I

    move-result v0

    if-lez v0, :cond_14

    const-string v0, "apdtk"

    invoke-interface {v3, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_11

    iget-object v5, v4, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    const-string v0, "apdtk"

    invoke-interface {v3, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-virtual {v5, v0}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->r(Ljava/lang/String;)V

    :cond_11
    const-string v0, "deviceId"

    invoke-interface {v3, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_12

    iget-object v5, v4, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    const-string v0, "deviceId"

    invoke-interface {v3, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-virtual {v5, v0}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->c(Ljava/lang/String;)V

    :cond_12
    const-string v0, "time"

    invoke-interface {v3, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_13

    iget-object v5, v4, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    const-string v0, "time"

    invoke-interface {v3, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-virtual {v5, v0}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->q(Ljava/lang/String;)V

    :cond_13
    const-string v0, "rule"

    invoke-interface {v3, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_14

    iget-object v5, v4, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    const-string v0, "rule"

    invoke-interface {v3, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-virtual {v5, v0}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->d(Ljava/lang/String;)V

    :cond_14
    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->a()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_19

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->a()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v0

    if-le v0, v7, :cond_19

    iget-object v0, v4, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->a()Ljava/lang/String;

    move-result-object v3

    const/4 v5, 0x0

    const/16 v6, 0x20

    invoke-virtual {v3, v5, v6}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->b(Ljava/lang/String;)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0
    .catch Ljava/lang/Throwable; {:try_start_1 .. :try_end_1} :catch_1

    :cond_15
    :goto_0
    :try_start_2
    iget-object v5, p0, Lcom/alipay/mobilesecuritysdk/deviceID/d;->b:Landroid/content/Context;

    sget-object v6, Lcom/alipay/mobilesecuritysdk/deviceID/c;->a:Ljava/util/Map;

    if-eqz v6, :cond_23

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->a()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_1c

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->a()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v0

    if-lez v0, :cond_1c

    move v0, v1

    :goto_1
    if-eqz v0, :cond_1e

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->b()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_1d

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->b()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v0

    if-lez v0, :cond_1d

    move v0, v1

    :goto_2
    if-eqz v0, :cond_1e

    move v0, v1

    :goto_3
    invoke-static {v6}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->a(Ljava/util/Map;)Z

    move-result v1

    if-eqz v1, :cond_23

    if-nez v0, :cond_16

    const-string v0, "priDeviceId"

    invoke-interface {v6, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_16

    const-string v0, "time"

    invoke-interface {v6, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_16

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v0, "priDeviceId"

    invoke-interface {v6, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v0, "time"

    invoke-interface {v6, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v4, v0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->a(Ljava/lang/String;)V

    invoke-virtual {v4, v0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->b(Ljava/lang/String;)V

    :cond_16
    const-string v0, "checkcode"

    invoke-interface {v6, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->c()Ljava/lang/String;

    move-result-object v1

    if-nez v1, :cond_17

    const-string v1, ""

    :cond_17
    invoke-static {v1}, Lcom/alipay/mobilesecuritysdk/util/a;->c(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    if-nez v1, :cond_1f

    const-string v1, ""

    move-object v3, v1

    :goto_4
    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->a()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->b()Ljava/lang/String;

    move-result-object v7

    invoke-static {v1}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v8

    if-nez v8, :cond_20

    iget-object v7, v4, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v7}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->c()Ljava/lang/String;

    move-result-object v7

    const/4 v8, 0x0

    const/16 v9, 0x20

    invoke-virtual {v1, v8, v9}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v7, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    :goto_5
    if-eqz v1, :cond_23

    if-eqz v0, :cond_18

    if-nez v3, :cond_22

    :cond_18
    move v0, v2

    :goto_6
    if-eqz v0, :cond_23

    const-string v0, "apdid"

    invoke-interface {v6, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_2
    .catch Ljava/lang/Throwable; {:try_start_2 .. :try_end_2} :catch_1

    :goto_7
    return-void

    :cond_19
    :try_start_3
    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->b()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_15

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->b()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v0

    if-le v0, v7, :cond_15

    iget-object v0, v4, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->b()Ljava/lang/String;

    move-result-object v3

    const/4 v5, 0x0

    const/16 v6, 0x20

    invoke-virtual {v3, v5, v6}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->b(Ljava/lang/String;)V
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_0
    .catch Ljava/lang/Throwable; {:try_start_3 .. :try_end_3} :catch_1

    goto/16 :goto_0

    :catch_0
    move-exception v0

    :try_start_4
    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/deviceID/i;->a(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v4, v0}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->c(Ljava/lang/String;)V
    :try_end_4
    .catch Ljava/lang/Throwable; {:try_start_4 .. :try_end_4} :catch_1

    goto/16 :goto_0

    :catch_1
    move-exception v0

    move-object v1, v0

    new-instance v3, Ljava/util/ArrayList;

    invoke-direct {v3}, Ljava/util/ArrayList;-><init>()V

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/d;->c:Ljava/util/Map;

    const-string v4, "tid"

    invoke-interface {v0, v4}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    if-eqz v0, :cond_1a

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/d;->c:Ljava/util/Map;

    const-string v4, "tid"

    invoke-interface {v0, v4}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v0

    if-le v0, v10, :cond_1a

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/d;->c:Ljava/util/Map;

    const-string v4, "tid"

    invoke-interface {v0, v4}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-virtual {v0, v2, v10}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0

    invoke-interface {v3, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :cond_1a
    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/d;->c:Ljava/util/Map;

    const-string v4, "utdid"

    invoke-interface {v0, v4}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    if-eqz v0, :cond_1b

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/d;->c:Ljava/util/Map;

    const-string v4, "utdid"

    invoke-interface {v0, v4}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v0

    if-le v0, v10, :cond_1b

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/deviceID/d;->c:Ljava/util/Map;

    const-string v4, "utdid"

    invoke-interface {v0, v4}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-virtual {v0, v2, v10}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0

    invoke-interface {v3, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :cond_1b
    invoke-static {v1}, Lcom/alipay/mobilesecuritysdk/deviceID/i;->a(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v0

    invoke-interface {v3, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    invoke-static {v3}, Lcom/alipay/mobilesecuritysdk/deviceID/i;->a(Ljava/util/List;)V

    goto/16 :goto_7

    :cond_1c
    move v0, v2

    goto/16 :goto_1

    :cond_1d
    move v0, v2

    goto/16 :goto_2

    :cond_1e
    move v0, v2

    goto/16 :goto_3

    :cond_1f
    move-object v3, v1

    goto/16 :goto_4

    :cond_20
    :try_start_5
    invoke-static {v7}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_21

    iget-object v1, v4, Lcom/alipay/mobilesecuritysdk/deviceID/f;->C:Lcom/alipay/mobilesecuritysdk/deviceID/g;

    invoke-virtual {v1}, Lcom/alipay/mobilesecuritysdk/deviceID/g;->c()Ljava/lang/String;

    move-result-object v1

    const/4 v8, 0x0

    const/16 v9, 0x20

    invoke-virtual {v7, v8, v9}, Ljava/lang/String;->subSequence(II)Ljava/lang/CharSequence;

    move-result-object v7

    invoke-virtual {v1, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    goto/16 :goto_5

    :cond_21
    move v1, v2

    goto/16 :goto_5

    :cond_22
    invoke-virtual {v0, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    goto/16 :goto_6

    :cond_23
    invoke-virtual {v4, v5}, Lcom/alipay/mobilesecuritysdk/deviceID/f;->b(Landroid/content/Context;)Ljava/lang/String;
    :try_end_5
    .catch Ljava/lang/Throwable; {:try_start_5 .. :try_end_5} :catch_1

    goto/16 :goto_7
.end method
