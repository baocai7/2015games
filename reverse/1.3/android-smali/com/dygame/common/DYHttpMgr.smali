.class public Lcom/dygame/common/DYHttpMgr;
.super Ljava/lang/Object;
.source "DYHttpMgr.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/dygame/common/DYHttpMgr$DYHttpHandler;
    }
.end annotation


# static fields
.field public static ON_RESP_FAIL:I

.field public static ON_RESP_SUCC:I


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 26
    const/16 v0, 0x3e8

    sput v0, Lcom/dygame/common/DYHttpMgr;->ON_RESP_SUCC:I

    .line 27
    const/16 v0, 0x3e9

    sput v0, Lcom/dygame/common/DYHttpMgr;->ON_RESP_FAIL:I

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .prologue
    .line 24
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 29
    return-void
.end method

.method public static get(Ljava/lang/String;Ljava/util/AbstractMap;Lcom/dygame/common/DYHttpMgr$DYHttpHandler;)V
    .locals 8
    .param p0, "uri"    # Ljava/lang/String;
    .param p2, "handler"    # Lcom/dygame/common/DYHttpMgr$DYHttpHandler;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "Ljava/util/AbstractMap",
            "<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;",
            "Lcom/dygame/common/DYHttpMgr$DYHttpHandler;",
            ")V"
        }
    .end annotation

    .prologue
    .line 173
    .local p1, "param":Ljava/util/AbstractMap;, "Ljava/util/AbstractMap<Ljava/lang/String;Ljava/lang/String;>;"
    const-string v1, ""

    .line 174
    .local v1, "params":Ljava/lang/String;
    const-string v3, ""

    .line 175
    .local v3, "url":Ljava/lang/String;
    if-eqz p1, :cond_2

    .line 176
    invoke-virtual {p1}, Ljava/util/AbstractMap;->entrySet()Ljava/util/Set;

    move-result-object v5

    invoke-interface {v5}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v6

    :goto_0
    invoke-interface {v6}, Ljava/util/Iterator;->hasNext()Z

    move-result v5

    if-eqz v5, :cond_1

    invoke-interface {v6}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/Map$Entry;

    .line 177
    .local v0, "entry":Ljava/util/Map$Entry;, "Ljava/util/Map$Entry<Ljava/lang/String;Ljava/lang/String;>;"
    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v5

    if-lez v5, :cond_0

    .line 178
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v7, "&"

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 180
    :cond_0
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    invoke-interface {v0}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Ljava/lang/String;

    invoke-virtual {v7, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v7, "="

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    invoke-interface {v0}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Ljava/lang/String;

    invoke-virtual {v7, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 181
    goto :goto_0

    .line 182
    .end local v0    # "entry":Ljava/util/Map$Entry;, "Ljava/util/Map$Entry<Ljava/lang/String;Ljava/lang/String;>;"
    :cond_1
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v5, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, "?"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 187
    :goto_1
    move-object v4, v3

    .line 188
    .local v4, "urlApi":Ljava/lang/String;
    new-instance v2, Ljava/lang/Thread;

    new-instance v5, Lcom/dygame/common/DYHttpMgr$3;

    invoke-direct {v5, v4, p2}, Lcom/dygame/common/DYHttpMgr$3;-><init>(Ljava/lang/String;Lcom/dygame/common/DYHttpMgr$DYHttpHandler;)V

    invoke-direct {v2, v5}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    .line 243
    .local v2, "thread":Ljava/lang/Thread;
    invoke-virtual {v2}, Ljava/lang/Thread;->start()V

    .line 244
    return-void

    .line 185
    .end local v2    # "thread":Ljava/lang/Thread;
    .end local v4    # "urlApi":Ljava/lang/String;
    :cond_2
    move-object v3, p0

    goto :goto_1
.end method

.method public static post(Ljava/lang/String;Ljava/util/AbstractMap;Lcom/dygame/common/DYHttpMgr$DYHttpHandler;)V
    .locals 7
    .param p0, "uri"    # Ljava/lang/String;
    .param p2, "handler"    # Lcom/dygame/common/DYHttpMgr$DYHttpHandler;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "Ljava/util/AbstractMap",
            "<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;",
            "Lcom/dygame/common/DYHttpMgr$DYHttpHandler;",
            ")V"
        }
    .end annotation

    .prologue
    .line 42
    .local p1, "param":Ljava/util/AbstractMap;, "Ljava/util/AbstractMap<Ljava/lang/String;Ljava/lang/String;>;"
    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    .line 43
    .local v2, "pairList":Ljava/util/List;, "Ljava/util/List<Lorg/apache/http/NameValuePair;>;"
    if-eqz p1, :cond_0

    .line 44
    invoke-virtual {p1}, Ljava/util/AbstractMap;->entrySet()Ljava/util/Set;

    move-result-object v4

    invoke-interface {v4}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v6

    :goto_0
    invoke-interface {v6}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_0

    invoke-interface {v6}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/Map$Entry;

    .line 45
    .local v0, "entry":Ljava/util/Map$Entry;, "Ljava/util/Map$Entry<Ljava/lang/String;Ljava/lang/String;>;"
    new-instance v1, Lorg/apache/http/message/BasicNameValuePair;

    invoke-interface {v0}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/String;

    invoke-interface {v0}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Ljava/lang/String;

    invoke-direct {v1, v4, v5}, Lorg/apache/http/message/BasicNameValuePair;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    .line 46
    .local v1, "pair":Lorg/apache/http/NameValuePair;
    invoke-interface {v2, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_0

    .line 50
    .end local v0    # "entry":Ljava/util/Map$Entry;, "Ljava/util/Map$Entry<Ljava/lang/String;Ljava/lang/String;>;"
    .end local v1    # "pair":Lorg/apache/http/NameValuePair;
    :cond_0
    new-instance v3, Ljava/lang/Thread;

    new-instance v4, Lcom/dygame/common/DYHttpMgr$1;

    invoke-direct {v4, v2, p0, p2}, Lcom/dygame/common/DYHttpMgr$1;-><init>(Ljava/util/List;Ljava/lang/String;Lcom/dygame/common/DYHttpMgr$DYHttpHandler;)V

    invoke-direct {v3, v4}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    .line 107
    .local v3, "thread":Ljava/lang/Thread;
    invoke-virtual {v3}, Ljava/lang/Thread;->start()V

    .line 108
    return-void
.end method

.method public static postEx(Ljava/lang/String;Ljava/lang/String;Lcom/dygame/common/DYHttpMgr$DYHttpHandler;)V
    .locals 2
    .param p0, "uri"    # Ljava/lang/String;
    .param p1, "param"    # Ljava/lang/String;
    .param p2, "handler"    # Lcom/dygame/common/DYHttpMgr$DYHttpHandler;

    .prologue
    .line 112
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/dygame/common/DYHttpMgr$2;

    invoke-direct {v1, p1, p0, p2}, Lcom/dygame/common/DYHttpMgr$2;-><init>(Ljava/lang/String;Ljava/lang/String;Lcom/dygame/common/DYHttpMgr$DYHttpHandler;)V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    .line 169
    .local v0, "thread":Ljava/lang/Thread;
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    .line 170
    return-void
.end method
