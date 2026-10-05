.class final Lcom/dygame/common/DYHttpMgr$1;
.super Ljava/lang/Object;
.source "DYHttpMgr.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/dygame/common/DYHttpMgr;->post(Ljava/lang/String;Ljava/util/AbstractMap;Lcom/dygame/common/DYHttpMgr$DYHttpHandler;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = null
.end annotation


# instance fields
.field final synthetic val$handler:Lcom/dygame/common/DYHttpMgr$DYHttpHandler;

.field final synthetic val$pairList:Ljava/util/List;

.field final synthetic val$uri:Ljava/lang/String;


# direct methods
.method constructor <init>(Ljava/util/List;Ljava/lang/String;Lcom/dygame/common/DYHttpMgr$DYHttpHandler;)V
    .locals 0

    .prologue
    .line 50
    iput-object p1, p0, Lcom/dygame/common/DYHttpMgr$1;->val$pairList:Ljava/util/List;

    iput-object p2, p0, Lcom/dygame/common/DYHttpMgr$1;->val$uri:Ljava/lang/String;

    iput-object p3, p0, Lcom/dygame/common/DYHttpMgr$1;->val$handler:Lcom/dygame/common/DYHttpMgr$DYHttpHandler;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 13

    .prologue
    .line 53
    const/4 v10, 0x0

    .line 57
    .local v10, "ret":Z
    :try_start_0
    new-instance v7, Lorg/apache/http/client/entity/UrlEncodedFormEntity;

    iget-object v11, p0, Lcom/dygame/common/DYHttpMgr$1;->val$pairList:Ljava/util/List;

    invoke-direct {v7, v11}, Lorg/apache/http/client/entity/UrlEncodedFormEntity;-><init>(Ljava/util/List;)V

    .line 59
    .local v7, "requestHttpEntity":Lorg/apache/http/HttpEntity;
    new-instance v3, Lorg/apache/http/client/methods/HttpPost;

    iget-object v11, p0, Lcom/dygame/common/DYHttpMgr$1;->val$uri:Ljava/lang/String;

    invoke-direct {v3, v11}, Lorg/apache/http/client/methods/HttpPost;-><init>(Ljava/lang/String;)V

    .line 61
    .local v3, "httpPost":Lorg/apache/http/client/methods/HttpPost;
    invoke-virtual {v3, v7}, Lorg/apache/http/client/methods/HttpPost;->setEntity(Lorg/apache/http/HttpEntity;)V

    .line 63
    new-instance v1, Lorg/apache/http/impl/client/DefaultHttpClient;

    invoke-direct {v1}, Lorg/apache/http/impl/client/DefaultHttpClient;-><init>()V

    .line 65
    .local v1, "httpClient":Lorg/apache/http/client/HttpClient;
    invoke-interface {v1, v3}, Lorg/apache/http/client/HttpClient;->execute(Lorg/apache/http/client/methods/HttpUriRequest;)Lorg/apache/http/HttpResponse;

    move-result-object v8

    .line 67
    .local v8, "response":Lorg/apache/http/HttpResponse;
    invoke-interface {v8}, Lorg/apache/http/HttpResponse;->getEntity()Lorg/apache/http/HttpEntity;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_1

    move-result-object v2

    .line 70
    .local v2, "httpEntity":Lorg/apache/http/HttpEntity;
    :try_start_1
    invoke-interface {v2}, Lorg/apache/http/HttpEntity;->getContent()Ljava/io/InputStream;

    move-result-object v4

    .line 71
    .local v4, "inputStream":Ljava/io/InputStream;
    new-instance v6, Ljava/io/BufferedReader;

    new-instance v11, Ljava/io/InputStreamReader;

    invoke-direct {v11, v4}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;)V

    invoke-direct {v6, v11}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    .line 73
    .local v6, "reader":Ljava/io/BufferedReader;
    const-string v9, ""

    .line 74
    .local v9, "result":Ljava/lang/String;
    const-string v5, ""

    .line 75
    .local v5, "line":Ljava/lang/String;
    :goto_0
    invoke-virtual {v6}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v5

    if-eqz v5, :cond_0

    .line 77
    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v11, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v11

    invoke-virtual {v11, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v11

    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v9

    goto :goto_0

    .line 80
    :cond_0
    const/4 v10, 0x1

    .line 81
    iget-object v11, p0, Lcom/dygame/common/DYHttpMgr$1;->val$handler:Lcom/dygame/common/DYHttpMgr$DYHttpHandler;

    invoke-virtual {v11, v9}, Lcom/dygame/common/DYHttpMgr$DYHttpHandler;->setRespData(Ljava/lang/String;)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    .line 95
    .end local v1    # "httpClient":Lorg/apache/http/client/HttpClient;
    .end local v2    # "httpEntity":Lorg/apache/http/HttpEntity;
    .end local v3    # "httpPost":Lorg/apache/http/client/methods/HttpPost;
    .end local v4    # "inputStream":Ljava/io/InputStream;
    .end local v5    # "line":Ljava/lang/String;
    .end local v6    # "reader":Ljava/io/BufferedReader;
    .end local v7    # "requestHttpEntity":Lorg/apache/http/HttpEntity;
    .end local v8    # "response":Lorg/apache/http/HttpResponse;
    .end local v9    # "result":Ljava/lang/String;
    :goto_1
    iget-object v11, p0, Lcom/dygame/common/DYHttpMgr$1;->val$handler:Lcom/dygame/common/DYHttpMgr$DYHttpHandler;

    if-eqz v11, :cond_1

    .line 96
    if-eqz v10, :cond_2

    .line 97
    iget-object v11, p0, Lcom/dygame/common/DYHttpMgr$1;->val$handler:Lcom/dygame/common/DYHttpMgr$DYHttpHandler;

    sget v12, Lcom/dygame/common/DYHttpMgr;->ON_RESP_SUCC:I

    invoke-virtual {v11, v12}, Lcom/dygame/common/DYHttpMgr$DYHttpHandler;->sendEmptyMessage(I)Z

    .line 105
    :cond_1
    :goto_2
    return-void

    .line 84
    .restart local v1    # "httpClient":Lorg/apache/http/client/HttpClient;
    .restart local v2    # "httpEntity":Lorg/apache/http/HttpEntity;
    .restart local v3    # "httpPost":Lorg/apache/http/client/methods/HttpPost;
    .restart local v7    # "requestHttpEntity":Lorg/apache/http/HttpEntity;
    .restart local v8    # "response":Lorg/apache/http/HttpResponse;
    :catch_0
    move-exception v0

    .line 86
    .local v0, "e":Ljava/lang/Exception;
    :try_start_2
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_1

    goto :goto_1

    .line 90
    .end local v0    # "e":Ljava/lang/Exception;
    .end local v1    # "httpClient":Lorg/apache/http/client/HttpClient;
    .end local v2    # "httpEntity":Lorg/apache/http/HttpEntity;
    .end local v3    # "httpPost":Lorg/apache/http/client/methods/HttpPost;
    .end local v7    # "requestHttpEntity":Lorg/apache/http/HttpEntity;
    .end local v8    # "response":Lorg/apache/http/HttpResponse;
    :catch_1
    move-exception v0

    .line 92
    .restart local v0    # "e":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_1

    .line 100
    .end local v0    # "e":Ljava/lang/Exception;
    :cond_2
    iget-object v11, p0, Lcom/dygame/common/DYHttpMgr$1;->val$handler:Lcom/dygame/common/DYHttpMgr$DYHttpHandler;

    sget v12, Lcom/dygame/common/DYHttpMgr;->ON_RESP_FAIL:I

    invoke-virtual {v11, v12}, Lcom/dygame/common/DYHttpMgr$DYHttpHandler;->sendEmptyMessage(I)Z

    goto :goto_2
.end method
