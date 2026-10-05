.class final Lcom/dygame/dysdk/DYHttpMgr$2;
.super Ljava/lang/Object;
.source "DYHttpMgr.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/dygame/dysdk/DYHttpMgr;->get(Ljava/lang/String;Ljava/util/HashMap;Lcom/dygame/dysdk/DYHttpMgr$DYHttpHandler;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = null
.end annotation


# instance fields
.field final synthetic val$handler:Lcom/dygame/dysdk/DYHttpMgr$DYHttpHandler;

.field final synthetic val$urlApi:Ljava/lang/String;


# direct methods
.method constructor <init>(Ljava/lang/String;Lcom/dygame/dysdk/DYHttpMgr$DYHttpHandler;)V
    .locals 0

    .prologue
    .line 127
    iput-object p1, p0, Lcom/dygame/dysdk/DYHttpMgr$2;->val$urlApi:Ljava/lang/String;

    iput-object p2, p0, Lcom/dygame/dysdk/DYHttpMgr$2;->val$handler:Lcom/dygame/dysdk/DYHttpMgr$DYHttpHandler;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 12

    .prologue
    .line 132
    new-instance v3, Lorg/apache/http/client/methods/HttpGet;

    iget-object v10, p0, Lcom/dygame/dysdk/DYHttpMgr$2;->val$urlApi:Ljava/lang/String;

    invoke-direct {v3, v10}, Lorg/apache/http/client/methods/HttpGet;-><init>(Ljava/lang/String;)V

    .line 133
    .local v3, "httpGet":Lorg/apache/http/client/methods/HttpGet;
    new-instance v1, Lorg/apache/http/impl/client/DefaultHttpClient;

    invoke-direct {v1}, Lorg/apache/http/impl/client/DefaultHttpClient;-><init>()V

    .line 134
    .local v1, "httpClient":Lorg/apache/http/client/HttpClient;
    const/4 v9, 0x0

    .line 140
    .local v9, "ret":Z
    :try_start_0
    invoke-interface {v1, v3}, Lorg/apache/http/client/HttpClient;->execute(Lorg/apache/http/client/methods/HttpUriRequest;)Lorg/apache/http/HttpResponse;

    move-result-object v7

    .line 142
    .local v7, "response":Lorg/apache/http/HttpResponse;
    invoke-interface {v7}, Lorg/apache/http/HttpResponse;->getEntity()Lorg/apache/http/HttpEntity;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_1

    move-result-object v2

    .line 145
    .local v2, "httpEntity":Lorg/apache/http/HttpEntity;
    :try_start_1
    invoke-interface {v2}, Lorg/apache/http/HttpEntity;->getContent()Ljava/io/InputStream;

    move-result-object v4

    .line 146
    .local v4, "inputStream":Ljava/io/InputStream;
    new-instance v6, Ljava/io/BufferedReader;

    new-instance v10, Ljava/io/InputStreamReader;

    invoke-direct {v10, v4}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;)V

    invoke-direct {v6, v10}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    .line 148
    .local v6, "reader":Ljava/io/BufferedReader;
    const-string v8, ""

    .line 149
    .local v8, "result":Ljava/lang/String;
    const-string v5, ""

    .line 150
    .local v5, "line":Ljava/lang/String;
    :goto_0
    invoke-virtual {v6}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v5

    if-eqz v5, :cond_0

    .line 152
    new-instance v10, Ljava/lang/StringBuilder;

    invoke-direct {v10}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v10, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v10

    invoke-virtual {v10, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v10

    invoke-virtual {v10}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    goto :goto_0

    .line 155
    :cond_0
    const/4 v9, 0x1

    .line 157
    iget-object v10, p0, Lcom/dygame/dysdk/DYHttpMgr$2;->val$handler:Lcom/dygame/dysdk/DYHttpMgr$DYHttpHandler;

    if-eqz v10, :cond_1

    .line 158
    iget-object v10, p0, Lcom/dygame/dysdk/DYHttpMgr$2;->val$handler:Lcom/dygame/dysdk/DYHttpMgr$DYHttpHandler;

    invoke-virtual {v10, v8}, Lcom/dygame/dysdk/DYHttpMgr$DYHttpHandler;->setRespData(Ljava/lang/String;)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    .line 174
    .end local v2    # "httpEntity":Lorg/apache/http/HttpEntity;
    .end local v4    # "inputStream":Ljava/io/InputStream;
    .end local v5    # "line":Ljava/lang/String;
    .end local v6    # "reader":Ljava/io/BufferedReader;
    .end local v7    # "response":Lorg/apache/http/HttpResponse;
    .end local v8    # "result":Ljava/lang/String;
    :cond_1
    :goto_1
    iget-object v10, p0, Lcom/dygame/dysdk/DYHttpMgr$2;->val$handler:Lcom/dygame/dysdk/DYHttpMgr$DYHttpHandler;

    if-eqz v10, :cond_2

    .line 175
    if-eqz v9, :cond_3

    .line 176
    iget-object v10, p0, Lcom/dygame/dysdk/DYHttpMgr$2;->val$handler:Lcom/dygame/dysdk/DYHttpMgr$DYHttpHandler;

    sget v11, Lcom/dygame/dysdk/DYHttpMgr;->ON_RESP_SUCC:I

    invoke-virtual {v10, v11}, Lcom/dygame/dysdk/DYHttpMgr$DYHttpHandler;->sendEmptyMessage(I)Z

    .line 182
    :cond_2
    :goto_2
    return-void

    .line 162
    .restart local v2    # "httpEntity":Lorg/apache/http/HttpEntity;
    .restart local v7    # "response":Lorg/apache/http/HttpResponse;
    :catch_0
    move-exception v0

    .line 164
    .local v0, "e":Ljava/lang/Exception;
    :try_start_2
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_1

    goto :goto_1

    .line 169
    .end local v0    # "e":Ljava/lang/Exception;
    .end local v2    # "httpEntity":Lorg/apache/http/HttpEntity;
    .end local v7    # "response":Lorg/apache/http/HttpResponse;
    :catch_1
    move-exception v0

    .line 171
    .restart local v0    # "e":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_1

    .line 179
    .end local v0    # "e":Ljava/lang/Exception;
    :cond_3
    iget-object v10, p0, Lcom/dygame/dysdk/DYHttpMgr$2;->val$handler:Lcom/dygame/dysdk/DYHttpMgr$DYHttpHandler;

    sget v11, Lcom/dygame/dysdk/DYHttpMgr;->ON_RESP_FAIL:I

    invoke-virtual {v10, v11}, Lcom/dygame/dysdk/DYHttpMgr$DYHttpHandler;->sendEmptyMessage(I)Z

    goto :goto_2
.end method
