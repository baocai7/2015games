.class public Lcn/uc/a/a/a/a/e;
.super Ljava/lang/Object;


# static fields
.field private static final a:Ljava/lang/String; = "RequestParams"

.field private static e:Lcn/uc/a/a/a/a/a;

.field private static f:Lcn/uc/a/a/a/a/b;


# instance fields
.field private b:J

.field private c:Ljava/lang/String;

.field private d:Lorg/json/JSONObject;

.field private g:Z


# direct methods
.method public constructor <init>(Ljava/lang/String;Ljava/lang/String;)V
    .locals 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    iput-boolean v0, p0, Lcn/uc/a/a/a/a/e;->g:Z

    sget-object v0, Lcn/uc/a/a/a/a/e;->e:Lcn/uc/a/a/a/a/a;

    if-nez v0, :cond_1

    new-instance v0, Lcn/uc/a/a/a/a/a;

    invoke-direct {v0, p2}, Lcn/uc/a/a/a/a/a;-><init>(Ljava/lang/String;)V

    sput-object v0, Lcn/uc/a/a/a/a/e;->e:Lcn/uc/a/a/a/a/a;

    :goto_0
    sget-object v0, Lcn/uc/a/a/a/a/e;->f:Lcn/uc/a/a/a/a/b;

    if-nez v0, :cond_0

    new-instance v0, Lcn/uc/a/a/a/a/b;

    invoke-direct {v0}, Lcn/uc/a/a/a/a/b;-><init>()V

    sput-object v0, Lcn/uc/a/a/a/a/e;->f:Lcn/uc/a/a/a/a/b;

    :cond_0
    iput-object p1, p0, Lcn/uc/a/a/a/a/e;->c:Ljava/lang/String;

    return-void

    :cond_1
    sget-object v0, Lcn/uc/a/a/a/a/e;->e:Lcn/uc/a/a/a/a/a;

    invoke-virtual {v0}, Lcn/uc/a/a/a/a/a;->g()Z

    move-result v0

    if-nez v0, :cond_2

    new-instance v0, Lcn/uc/a/a/a/a/a;

    invoke-direct {v0, p2}, Lcn/uc/a/a/a/a/a;-><init>(Ljava/lang/String;)V

    sput-object v0, Lcn/uc/a/a/a/a/e;->e:Lcn/uc/a/a/a/a/a;

    goto :goto_0

    :cond_2
    sget-object v0, Lcn/uc/a/a/a/a/e;->e:Lcn/uc/a/a/a/a/a;

    invoke-virtual {v0, p2}, Lcn/uc/a/a/a/a/a;->a(Ljava/lang/String;)V

    goto :goto_0
.end method

.method public constructor <init>(Ljava/lang/String;ZLjava/lang/String;)V
    .locals 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-boolean p2, p0, Lcn/uc/a/a/a/a/e;->g:Z

    sget-object v0, Lcn/uc/a/a/a/a/e;->e:Lcn/uc/a/a/a/a/a;

    if-nez v0, :cond_1

    new-instance v0, Lcn/uc/a/a/a/a/a;

    invoke-direct {v0, p3}, Lcn/uc/a/a/a/a/a;-><init>(Ljava/lang/String;)V

    sput-object v0, Lcn/uc/a/a/a/a/e;->e:Lcn/uc/a/a/a/a/a;

    :goto_0
    sget-object v0, Lcn/uc/a/a/a/a/e;->f:Lcn/uc/a/a/a/a/b;

    if-nez v0, :cond_0

    new-instance v0, Lcn/uc/a/a/a/a/b;

    invoke-direct {v0}, Lcn/uc/a/a/a/a/b;-><init>()V

    sput-object v0, Lcn/uc/a/a/a/a/e;->f:Lcn/uc/a/a/a/a/b;

    :cond_0
    iput-object p1, p0, Lcn/uc/a/a/a/a/e;->c:Ljava/lang/String;

    return-void

    :cond_1
    sget-object v0, Lcn/uc/a/a/a/a/e;->e:Lcn/uc/a/a/a/a/a;

    invoke-virtual {v0}, Lcn/uc/a/a/a/a/a;->g()Z

    move-result v0

    if-nez v0, :cond_2

    new-instance v0, Lcn/uc/a/a/a/a/a;

    invoke-direct {v0, p3}, Lcn/uc/a/a/a/a/a;-><init>(Ljava/lang/String;)V

    sput-object v0, Lcn/uc/a/a/a/a/e;->e:Lcn/uc/a/a/a/a/a;

    goto :goto_0

    :cond_2
    sget-object v0, Lcn/uc/a/a/a/a/e;->e:Lcn/uc/a/a/a/a/a;

    invoke-virtual {v0, p3}, Lcn/uc/a/a/a/a/a;->a(Ljava/lang/String;)V

    goto :goto_0
.end method


# virtual methods
.method public a()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcn/uc/a/a/a/a/e;->c:Ljava/lang/String;

    return-object v0
.end method

.method public a(Lcn/uc/a/a/a/a/c;)V
    .locals 1

    if-eqz p1, :cond_0

    invoke-interface {p1}, Lcn/uc/a/a/a/a/c;->a()Lorg/json/JSONObject;

    move-result-object v0

    iput-object v0, p0, Lcn/uc/a/a/a/a/e;->d:Lorg/json/JSONObject;

    :cond_0
    return-void
.end method

.method public a(Ljava/lang/String;)V
    .locals 1

    :try_start_0
    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0, p1}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    iput-object v0, p0, Lcn/uc/a/a/a/a/e;->d:Lorg/json/JSONObject;
    :try_end_0
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_0

    :goto_0
    return-void

    :catch_0
    move-exception v0

    goto :goto_0
.end method

.method public toString()Ljava/lang/String;
    .locals 4

    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V

    :try_start_0
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v1

    iput-wide v1, p0, Lcn/uc/a/a/a/a/e;->b:J

    const-string v1, "id"

    iget-wide v2, p0, Lcn/uc/a/a/a/a/e;->b:J

    invoke-virtual {v0, v1, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;J)Lorg/json/JSONObject;

    const-string v1, "service"

    iget-object v2, p0, Lcn/uc/a/a/a/a/e;->c:Ljava/lang/String;

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    iget-object v1, p0, Lcn/uc/a/a/a/a/e;->d:Lorg/json/JSONObject;

    if-eqz v1, :cond_0

    const-string v1, "data"

    iget-object v2, p0, Lcn/uc/a/a/a/a/e;->d:Lorg/json/JSONObject;

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    :goto_0
    sget-object v1, Lcn/uc/a/a/a/a/e;->f:Lcn/uc/a/a/a/a/b;

    if-eqz v1, :cond_1

    const-string v1, "game"

    sget-object v2, Lcn/uc/a/a/a/a/e;->f:Lcn/uc/a/a/a/a/b;

    invoke-virtual {v2}, Lcn/uc/a/a/a/a/b;->f()Lorg/json/JSONObject;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    :goto_1
    sget-object v1, Lcn/uc/a/a/a/a/e;->e:Lcn/uc/a/a/a/a/a;

    if-eqz v1, :cond_2

    sget-object v1, Lcn/uc/a/a/a/a/e;->e:Lcn/uc/a/a/a/a/a;

    iget-boolean v2, p0, Lcn/uc/a/a/a/a/e;->g:Z

    invoke-virtual {v1, v2}, Lcn/uc/a/a/a/a/a;->a(Z)V

    const-string v1, "client"

    sget-object v2, Lcn/uc/a/a/a/a/e;->e:Lcn/uc/a/a/a/a/a;

    invoke-virtual {v2}, Lcn/uc/a/a/a/a/a;->h()Lorg/json/JSONObject;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :goto_2
    invoke-virtual {v0}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0

    :cond_0
    :try_start_1
    const-string v1, "data"

    const-string v2, ""

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    goto :goto_0

    :catch_0
    move-exception v1

    goto :goto_2

    :cond_1
    const-string v1, "game"

    const-string v2, ""

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    goto :goto_1

    :cond_2
    const-string v1, "client"

    const-string v2, ""

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_2
.end method
