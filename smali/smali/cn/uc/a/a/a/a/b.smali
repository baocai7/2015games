.class public Lcn/uc/a/a/a/a/b;
.super Ljava/lang/Object;


# static fields
.field private static final a:Ljava/lang/String; = "GameParams"


# instance fields
.field private b:I

.field private c:I

.field private d:Ljava/lang/String;

.field private e:I

.field private f:Ljava/lang/String;


# direct methods
.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    invoke-direct {p0}, Lcn/uc/a/a/a/a/b;->g()V

    return-void
.end method

.method private g()V
    .locals 1

    :try_start_0
    const-string v0, "key_cp_id"

    invoke-static {v0}, Lcn/uc/a/a/a/a;->b(Ljava/lang/String;)I

    move-result v0

    iput v0, p0, Lcn/uc/a/a/a/a/b;->b:I

    const-string v0, "key_gameId"

    invoke-static {v0}, Lcn/uc/a/a/a/a;->b(Ljava/lang/String;)I

    move-result v0

    iput v0, p0, Lcn/uc/a/a/a/a/b;->c:I

    const-string v0, "key_channel_id"

    invoke-static {v0}, Lcn/uc/a/a/a/a;->c(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcn/uc/a/a/a/a/b;->d:Ljava/lang/String;

    const-string v0, "key_server_id"

    invoke-static {v0}, Lcn/uc/a/a/a/a;->b(Ljava/lang/String;)I

    move-result v0

    iput v0, p0, Lcn/uc/a/a/a/a/b;->e:I

    const-string v0, "key_server_name"

    invoke-static {v0}, Lcn/uc/a/a/a/a;->c(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcn/uc/a/a/a/a/b;->f:Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :goto_0
    return-void

    :catch_0
    move-exception v0

    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_0
.end method


# virtual methods
.method public a()I
    .locals 1

    iget v0, p0, Lcn/uc/a/a/a/a/b;->b:I

    return v0
.end method

.method public a(I)V
    .locals 0

    iput p1, p0, Lcn/uc/a/a/a/a/b;->e:I

    return-void
.end method

.method public a(Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcn/uc/a/a/a/a/b;->f:Ljava/lang/String;

    return-void
.end method

.method public b()I
    .locals 1

    iget v0, p0, Lcn/uc/a/a/a/a/b;->c:I

    return v0
.end method

.method public c()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcn/uc/a/a/a/a/b;->d:Ljava/lang/String;

    return-object v0
.end method

.method public d()I
    .locals 1

    iget v0, p0, Lcn/uc/a/a/a/a/b;->e:I

    return v0
.end method

.method public e()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcn/uc/a/a/a/a/b;->f:Ljava/lang/String;

    return-object v0
.end method

.method public f()Lorg/json/JSONObject;
    .locals 5

    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1}, Lorg/json/JSONObject;-><init>()V

    invoke-direct {p0}, Lcn/uc/a/a/a/a/b;->g()V

    :try_start_0
    const-string v0, "cpId"

    iget v2, p0, Lcn/uc/a/a/a/a/b;->b:I

    invoke-virtual {v1, v0, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    const-string v0, "gameId"

    iget v2, p0, Lcn/uc/a/a/a/a/b;->c:I

    invoke-virtual {v1, v0, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    const-string v0, "channelId"

    iget-object v2, p0, Lcn/uc/a/a/a/a/b;->d:Ljava/lang/String;

    invoke-virtual {v1, v0, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string v0, "serverId"

    iget v2, p0, Lcn/uc/a/a/a/a/b;->e:I

    invoke-virtual {v1, v0, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    const-string v0, "serverName"

    iget-object v2, p0, Lcn/uc/a/a/a/a/b;->f:Ljava/lang/String;

    invoke-virtual {v1, v0, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :goto_0
    return-object v1

    :catch_0
    move-exception v0

    const-string v2, "GameParams"

    const-string v3, "toJsonObject"

    const-string v4, ""

    invoke-static {v2, v3, v4, v0}, Lcn/uc/a/a/a/i;->b(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;)V

    goto :goto_0
.end method

.method public toString()Ljava/lang/String;
    .locals 1

    invoke-virtual {p0}, Lcn/uc/a/a/a/a/b;->f()Lorg/json/JSONObject;

    move-result-object v0

    invoke-virtual {v0}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method
