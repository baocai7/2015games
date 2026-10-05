.class public final Lcom/alipay/sdk/protocol/b;
.super Ljava/lang/Object;
.source "SourceFile"


# instance fields
.field a:Ljava/lang/String;

.field b:Ljava/lang/String;

.field c:Ljava/lang/String;

.field d:Ljava/lang/String;

.field e:Ljava/lang/String;

.field f:Z

.field g:Z

.field h:Z

.field i:Ljava/lang/String;

.field j:Ljava/lang/String;

.field k:Ljava/lang/String;

.field l:Lorg/json/JSONObject;


# direct methods
.method private constructor <init>(Ljava/lang/String;)V
    .locals 1

    .prologue
    const/4 v0, 0x1

    .line 34
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 27
    iput-boolean v0, p0, Lcom/alipay/sdk/protocol/b;->g:Z

    .line 28
    iput-boolean v0, p0, Lcom/alipay/sdk/protocol/b;->h:Z

    .line 35
    iput-object p1, p0, Lcom/alipay/sdk/protocol/b;->a:Ljava/lang/String;

    .line 36
    return-void
.end method

.method private static a(Ljava/lang/String;Lcom/alipay/sdk/protocol/a;)Lcom/alipay/sdk/protocol/b;
    .locals 12

    .prologue
    .line 139
    iget-object v1, p1, Lcom/alipay/sdk/protocol/a;->i:Ljava/lang/String;

    iget-object v2, p1, Lcom/alipay/sdk/protocol/a;->j:Ljava/lang/String;

    iget-object v3, p1, Lcom/alipay/sdk/protocol/a;->k:Ljava/lang/String;

    iget-object v4, p1, Lcom/alipay/sdk/protocol/a;->l:Ljava/lang/String;

    iget-boolean v5, p1, Lcom/alipay/sdk/protocol/a;->m:Z

    iget-boolean v6, p1, Lcom/alipay/sdk/protocol/a;->n:Z

    iget-boolean v7, p1, Lcom/alipay/sdk/protocol/a;->o:Z

    iget-object v8, p1, Lcom/alipay/sdk/protocol/a;->p:Ljava/lang/String;

    iget-object v9, p1, Lcom/alipay/sdk/protocol/a;->q:Ljava/lang/String;

    iget-object v10, p1, Lcom/alipay/sdk/protocol/a;->r:Ljava/lang/String;

    iget-object v11, p1, Lcom/alipay/sdk/protocol/a;->s:Lorg/json/JSONObject;

    move-object v0, p0

    invoke-static/range {v0 .. v11}, Lcom/alipay/sdk/protocol/b;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZZZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lorg/json/JSONObject;)Lcom/alipay/sdk/protocol/b;

    move-result-object v0

    return-object v0
.end method

.method private static a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZZZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lorg/json/JSONObject;)Lcom/alipay/sdk/protocol/b;
    .locals 3

    .prologue
    const/4 v0, 0x0

    .line 119
    invoke-static {p0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 135
    :goto_0
    return-object v0

    .line 122
    :cond_0
    new-instance v1, Lcom/alipay/sdk/protocol/b;

    invoke-direct {v1, p0}, Lcom/alipay/sdk/protocol/b;-><init>(Ljava/lang/String;)V

    .line 123
    iput-object p0, v1, Lcom/alipay/sdk/protocol/b;->a:Ljava/lang/String;

    .line 124
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_1

    :goto_1
    iput-object v0, v1, Lcom/alipay/sdk/protocol/b;->b:Ljava/lang/String;

    .line 125
    iput-object p2, v1, Lcom/alipay/sdk/protocol/b;->c:Ljava/lang/String;

    .line 126
    iput-object p3, v1, Lcom/alipay/sdk/protocol/b;->d:Ljava/lang/String;

    .line 127
    iput-object p4, v1, Lcom/alipay/sdk/protocol/b;->e:Ljava/lang/String;

    .line 128
    iput-boolean p5, v1, Lcom/alipay/sdk/protocol/b;->f:Z

    .line 129
    iput-boolean p6, v1, Lcom/alipay/sdk/protocol/b;->g:Z

    .line 130
    iput-boolean p7, v1, Lcom/alipay/sdk/protocol/b;->h:Z

    .line 131
    iput-object p8, v1, Lcom/alipay/sdk/protocol/b;->i:Ljava/lang/String;

    .line 132
    iput-object p9, v1, Lcom/alipay/sdk/protocol/b;->j:Ljava/lang/String;

    .line 133
    iput-object p10, v1, Lcom/alipay/sdk/protocol/b;->k:Ljava/lang/String;

    .line 134
    iput-object p11, v1, Lcom/alipay/sdk/protocol/b;->l:Lorg/json/JSONObject;

    move-object v0, v1

    .line 135
    goto :goto_0

    .line 124
    :cond_1
    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    goto :goto_1
.end method

.method private static a(Lorg/json/JSONObject;)Lcom/alipay/sdk/protocol/b;
    .locals 12

    .prologue
    const/4 v4, 0x0

    const/4 v7, 0x1

    .line 56
    .line 57
    if-eqz p0, :cond_b

    const-string v0, "name"

    invoke-virtual {p0, v0}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_b

    .line 58
    const-string v0, "name"

    invoke-virtual {p0, v0}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 61
    :goto_0
    if-eqz p0, :cond_a

    const-string v1, "host"

    invoke-virtual {p0, v1}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_a

    .line 62
    const-string v1, "host"

    invoke-virtual {p0, v1}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 65
    :goto_1
    if-eqz p0, :cond_9

    const-string v2, "params"

    invoke-virtual {p0, v2}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_9

    .line 66
    const-string v2, "params"

    invoke-virtual {p0, v2}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 69
    :goto_2
    if-eqz p0, :cond_8

    const-string v3, "enctype"

    invoke-virtual {p0, v3}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_8

    .line 70
    const-string v3, "enctype"

    invoke-virtual {p0, v3}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 73
    :goto_3
    if-eqz p0, :cond_0

    const-string v5, "request_param"

    invoke-virtual {p0, v5}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_0

    .line 74
    const-string v4, "request_param"

    invoke-virtual {p0, v4}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    .line 77
    :cond_0
    if-eqz p0, :cond_7

    const-string v5, "validate"

    invoke-virtual {p0, v5}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_7

    .line 78
    const-string v5, "validate"

    invoke-virtual {p0, v5, v7}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;Z)Z

    move-result v5

    .line 82
    :goto_4
    if-eqz p0, :cond_6

    const-string v6, "https"

    invoke-virtual {p0, v6}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v6

    if-eqz v6, :cond_6

    .line 83
    const-string v6, "https"

    invoke-virtual {p0, v6}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;)Z

    move-result v6

    if-nez v6, :cond_5

    move v6, v7

    .line 87
    :goto_5
    if-eqz p0, :cond_1

    const-string v8, "formSubmit"

    invoke-virtual {p0, v8}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v8

    if-eqz v8, :cond_1

    .line 88
    const-string v7, "formSubmit"

    invoke-virtual {p0, v7}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;)Z

    move-result v7

    .line 91
    :cond_1
    const-string v8, ""

    .line 92
    if-eqz p0, :cond_2

    const-string v9, "namespace"

    invoke-virtual {p0, v9}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v9

    if-eqz v9, :cond_2

    .line 93
    const-string v8, "namespace"

    invoke-virtual {p0, v8}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    .line 96
    :cond_2
    const-string v9, ""

    .line 97
    if-eqz p0, :cond_3

    const-string v10, "apiVersion"

    invoke-virtual {p0, v10}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v10

    if-eqz v10, :cond_3

    .line 98
    const-string v9, "apiVersion"

    invoke-virtual {p0, v9}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9

    .line 101
    :cond_3
    const-string v10, ""

    .line 102
    if-eqz p0, :cond_4

    const-string v11, "apiName"

    invoke-virtual {p0, v11}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v11

    if-eqz v11, :cond_4

    .line 103
    const-string v10, "apiName"

    invoke-virtual {p0, v10}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v10

    :cond_4
    move-object v11, p0

    .line 106
    invoke-static/range {v0 .. v11}, Lcom/alipay/sdk/protocol/b;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZZZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lorg/json/JSONObject;)Lcom/alipay/sdk/protocol/b;

    move-result-object v0

    return-object v0

    .line 83
    :cond_5
    const/4 v6, 0x0

    goto :goto_5

    :cond_6
    move v6, v7

    goto :goto_5

    :cond_7
    move v5, v7

    goto :goto_4

    :cond_8
    move-object v3, v4

    goto/16 :goto_3

    :cond_9
    move-object v2, v4

    goto/16 :goto_2

    :cond_a
    move-object v1, v4

    goto/16 :goto_1

    :cond_b
    move-object v0, v4

    goto/16 :goto_0
.end method

.method public static a(Lorg/json/JSONObject;Ljava/lang/String;)Lcom/alipay/sdk/protocol/b;
    .locals 13

    .prologue
    const/4 v4, 0x0

    const/4 v7, 0x1

    .line 111
    invoke-virtual {p0, p1}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v11

    .line 112
    if-eqz v11, :cond_b

    const-string v0, "name"

    invoke-virtual {v11, v0}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_b

    const-string v0, "name"

    invoke-virtual {v11, v0}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :goto_0
    if-eqz v11, :cond_a

    const-string v1, "host"

    invoke-virtual {v11, v1}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_a

    const-string v1, "host"

    invoke-virtual {v11, v1}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    :goto_1
    if-eqz v11, :cond_9

    const-string v2, "params"

    invoke-virtual {v11, v2}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_9

    const-string v2, "params"

    invoke-virtual {v11, v2}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    :goto_2
    if-eqz v11, :cond_8

    const-string v3, "enctype"

    invoke-virtual {v11, v3}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_8

    const-string v3, "enctype"

    invoke-virtual {v11, v3}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    :goto_3
    if-eqz v11, :cond_0

    const-string v5, "request_param"

    invoke-virtual {v11, v5}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_0

    const-string v4, "request_param"

    invoke-virtual {v11, v4}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    :cond_0
    if-eqz v11, :cond_7

    const-string v5, "validate"

    invoke-virtual {v11, v5}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_7

    const-string v5, "validate"

    invoke-virtual {v11, v5, v7}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;Z)Z

    move-result v5

    :goto_4
    if-eqz v11, :cond_6

    const-string v6, "https"

    invoke-virtual {v11, v6}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v6

    if-eqz v6, :cond_6

    const-string v6, "https"

    invoke-virtual {v11, v6}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;)Z

    move-result v6

    if-nez v6, :cond_5

    move v6, v7

    :goto_5
    if-eqz v11, :cond_1

    const-string v8, "formSubmit"

    invoke-virtual {v11, v8}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v8

    if-eqz v8, :cond_1

    const-string v7, "formSubmit"

    invoke-virtual {v11, v7}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;)Z

    move-result v7

    :cond_1
    const-string v8, ""

    if-eqz v11, :cond_2

    const-string v9, "namespace"

    invoke-virtual {v11, v9}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v9

    if-eqz v9, :cond_2

    const-string v8, "namespace"

    invoke-virtual {v11, v8}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    :cond_2
    const-string v9, ""

    if-eqz v11, :cond_3

    const-string v10, "apiVersion"

    invoke-virtual {v11, v10}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v10

    if-eqz v10, :cond_3

    const-string v9, "apiVersion"

    invoke-virtual {v11, v9}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9

    :cond_3
    const-string v10, ""

    if-eqz v11, :cond_4

    const-string v12, "apiName"

    invoke-virtual {v11, v12}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v12

    if-eqz v12, :cond_4

    const-string v10, "apiName"

    invoke-virtual {v11, v10}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v10

    :cond_4
    invoke-static/range {v0 .. v11}, Lcom/alipay/sdk/protocol/b;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZZZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lorg/json/JSONObject;)Lcom/alipay/sdk/protocol/b;

    move-result-object v0

    return-object v0

    :cond_5
    const/4 v6, 0x0

    goto :goto_5

    :cond_6
    move v6, v7

    goto :goto_5

    :cond_7
    move v5, v7

    goto :goto_4

    :cond_8
    move-object v3, v4

    goto/16 :goto_3

    :cond_9
    move-object v2, v4

    goto/16 :goto_2

    :cond_a
    move-object v1, v4

    goto/16 :goto_1

    :cond_b
    move-object v0, v4

    goto/16 :goto_0
.end method

.method private b()Lorg/json/JSONObject;
    .locals 1

    .prologue
    .line 40
    iget-object v0, p0, Lcom/alipay/sdk/protocol/b;->l:Lorg/json/JSONObject;

    return-object v0
.end method

.method private c()Ljava/lang/String;
    .locals 1

    .prologue
    .line 44
    iget-object v0, p0, Lcom/alipay/sdk/protocol/b;->k:Ljava/lang/String;

    return-object v0
.end method

.method private d()Ljava/lang/String;
    .locals 1

    .prologue
    .line 48
    iget-object v0, p0, Lcom/alipay/sdk/protocol/b;->i:Ljava/lang/String;

    return-object v0
.end method

.method private e()Ljava/lang/String;
    .locals 1

    .prologue
    .line 52
    iget-object v0, p0, Lcom/alipay/sdk/protocol/b;->j:Ljava/lang/String;

    return-object v0
.end method

.method private f()Ljava/lang/String;
    .locals 1

    .prologue
    .line 147
    iget-object v0, p0, Lcom/alipay/sdk/protocol/b;->a:Ljava/lang/String;

    return-object v0
.end method

.method private g()Ljava/lang/String;
    .locals 1

    .prologue
    .line 151
    iget-object v0, p0, Lcom/alipay/sdk/protocol/b;->b:Ljava/lang/String;

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 152
    sget-object v0, Lcom/alipay/sdk/cons/a;->b:Ljava/lang/String;

    iput-object v0, p0, Lcom/alipay/sdk/protocol/b;->b:Ljava/lang/String;

    .line 154
    :cond_0
    iget-object v0, p0, Lcom/alipay/sdk/protocol/b;->b:Ljava/lang/String;

    return-object v0
.end method

.method private h()Ljava/lang/String;
    .locals 1

    .prologue
    .line 158
    iget-object v0, p0, Lcom/alipay/sdk/protocol/b;->c:Ljava/lang/String;

    return-object v0
.end method

.method private i()Ljava/lang/String;
    .locals 1

    .prologue
    .line 171
    iget-object v0, p0, Lcom/alipay/sdk/protocol/b;->d:Ljava/lang/String;

    return-object v0
.end method

.method private j()Ljava/lang/String;
    .locals 1

    .prologue
    .line 175
    iget-object v0, p0, Lcom/alipay/sdk/protocol/b;->e:Ljava/lang/String;

    return-object v0
.end method

.method private k()Z
    .locals 1

    .prologue
    .line 179
    iget-boolean v0, p0, Lcom/alipay/sdk/protocol/b;->f:Z

    return v0
.end method

.method private l()Z
    .locals 1

    .prologue
    .line 183
    iget-boolean v0, p0, Lcom/alipay/sdk/protocol/b;->g:Z

    return v0
.end method

.method private m()Z
    .locals 1

    .prologue
    .line 187
    iget-boolean v0, p0, Lcom/alipay/sdk/protocol/b;->h:Z

    return v0
.end method


# virtual methods
.method public final a()Lorg/json/JSONObject;
    .locals 3

    .prologue
    .line 162
    const/4 v1, 0x0

    .line 164
    :try_start_0
    new-instance v0, Lorg/json/JSONObject;

    iget-object v2, p0, Lcom/alipay/sdk/protocol/b;->c:Ljava/lang/String;

    invoke-direct {v0, v2}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 167
    :goto_0
    return-object v0

    :catch_0
    move-exception v0

    move-object v0, v1

    goto :goto_0
.end method
