.class public Lorg/cocos2dx/lua/MyPushMessageReceiver;
.super Lcom/baidu/frontia/api/FrontiaPushMessageReceiver;
.source "MyPushMessageReceiver.java"


# static fields
.field public static final TAG:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 41
    const-class v0, Lorg/cocos2dx/lua/MyPushMessageReceiver;

    .line 42
    invoke-virtual {v0}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v0

    .line 41
    sput-object v0, Lorg/cocos2dx/lua/MyPushMessageReceiver;->TAG:Ljava/lang/String;

    .line 42
    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .prologue
    .line 39
    invoke-direct {p0}, Lcom/baidu/frontia/api/FrontiaPushMessageReceiver;-><init>()V

    return-void
.end method

.method private updateContent(Landroid/content/Context;Ljava/lang/String;)V
    .locals 0
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "content"    # Ljava/lang/String;

    .prologue
    .line 270
    return-void
.end method


# virtual methods
.method public onBind(Landroid/content/Context;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 3
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "errorCode"    # I
    .param p3, "appid"    # Ljava/lang/String;
    .param p4, "userId"    # Ljava/lang/String;
    .param p5, "channelId"    # Ljava/lang/String;
    .param p6, "requestId"    # Ljava/lang/String;

    .prologue
    .line 66
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "onBind errorCode="

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " appid="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 67
    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " userId="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " channelId="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 68
    const-string v2, " requestId="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 66
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 69
    .local v0, "responseString":Ljava/lang/String;
    sget-object v1, Lorg/cocos2dx/lua/MyPushMessageReceiver;->TAG:Ljava/lang/String;

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 72
    if-nez p2, :cond_0

    .line 73
    const/4 v1, 0x1

    invoke-static {p1, v1}, Lorg/cocos2dx/lua/MyUtils;->setBind(Landroid/content/Context;Z)V

    .line 76
    :cond_0
    invoke-direct {p0, p1, v0}, Lorg/cocos2dx/lua/MyPushMessageReceiver;->updateContent(Landroid/content/Context;Ljava/lang/String;)V

    .line 77
    return-void
.end method

.method public onDelTags(Landroid/content/Context;ILjava/util/List;Ljava/util/List;Ljava/lang/String;)V
    .locals 3
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "errorCode"    # I
    .param p5, "requestId"    # Ljava/lang/String;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "I",
            "Ljava/util/List",
            "<",
            "Ljava/lang/String;",
            ">;",
            "Ljava/util/List",
            "<",
            "Ljava/lang/String;",
            ">;",
            "Ljava/lang/String;",
            ")V"
        }
    .end annotation

    .prologue
    .line 196
    .local p3, "sucessTags":Ljava/util/List;, "Ljava/util/List<Ljava/lang/String;>;"
    .local p4, "failTags":Ljava/util/List;, "Ljava/util/List<Ljava/lang/String;>;"
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "onDelTags errorCode="

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 197
    const-string v2, " sucessTags="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " failTags="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 198
    const-string v2, " requestId="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 196
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 199
    .local v0, "responseString":Ljava/lang/String;
    sget-object v1, Lorg/cocos2dx/lua/MyPushMessageReceiver;->TAG:Ljava/lang/String;

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 202
    invoke-direct {p0, p1, v0}, Lorg/cocos2dx/lua/MyPushMessageReceiver;->updateContent(Landroid/content/Context;Ljava/lang/String;)V

    .line 203
    return-void
.end method

.method public onListTags(Landroid/content/Context;ILjava/util/List;Ljava/lang/String;)V
    .locals 3
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "errorCode"    # I
    .param p4, "requestId"    # Ljava/lang/String;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "I",
            "Ljava/util/List",
            "<",
            "Ljava/lang/String;",
            ">;",
            "Ljava/lang/String;",
            ")V"
        }
    .end annotation

    .prologue
    .line 220
    .local p3, "tags":Ljava/util/List;, "Ljava/util/List<Ljava/lang/String;>;"
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "onListTags errorCode="

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " tags="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 221
    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 220
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 222
    .local v0, "responseString":Ljava/lang/String;
    sget-object v1, Lorg/cocos2dx/lua/MyPushMessageReceiver;->TAG:Ljava/lang/String;

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 225
    invoke-direct {p0, p1, v0}, Lorg/cocos2dx/lua/MyPushMessageReceiver;->updateContent(Landroid/content/Context;Ljava/lang/String;)V

    .line 226
    return-void
.end method

.method public onMessage(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V
    .locals 7
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "message"    # Ljava/lang/String;
    .param p3, "customContentString"    # Ljava/lang/String;

    .prologue
    .line 92
    new-instance v5, Ljava/lang/StringBuilder;

    const-string v6, "\u900f\u4f20\u6d88\u606f message=\""

    invoke-direct {v5, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v5, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    .line 93
    const-string v6, "\" customContentString="

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    .line 92
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 94
    .local v3, "messageString":Ljava/lang/String;
    sget-object v5, Lorg/cocos2dx/lua/MyPushMessageReceiver;->TAG:Ljava/lang/String;

    invoke-static {v5, v3}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 97
    invoke-static {p3}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v5

    if-nez v5, :cond_0

    .line 98
    const/4 v0, 0x0

    .line 100
    .local v0, "customJson":Lorg/json/JSONObject;
    :try_start_0
    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1, p3}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V
    :try_end_0
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_0

    .line 101
    .end local v0    # "customJson":Lorg/json/JSONObject;
    .local v1, "customJson":Lorg/json/JSONObject;
    const/4 v4, 0x0

    .line 102
    .local v4, "myvalue":Ljava/lang/String;
    :try_start_1
    const-string v5, "mykey"

    invoke-virtual {v1, v5}, Lorg/json/JSONObject;->isNull(Ljava/lang/String;)Z

    move-result v5

    if-nez v5, :cond_0

    .line 103
    const-string v5, "mykey"

    invoke-virtual {v1, v5}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;
    :try_end_1
    .catch Lorg/json/JSONException; {:try_start_1 .. :try_end_1} :catch_1

    .line 112
    .end local v1    # "customJson":Lorg/json/JSONObject;
    .end local v4    # "myvalue":Ljava/lang/String;
    :cond_0
    :goto_0
    invoke-direct {p0, p1, v3}, Lorg/cocos2dx/lua/MyPushMessageReceiver;->updateContent(Landroid/content/Context;Ljava/lang/String;)V

    .line 113
    return-void

    .line 105
    .restart local v0    # "customJson":Lorg/json/JSONObject;
    :catch_0
    move-exception v2

    .line 107
    .local v2, "e":Lorg/json/JSONException;
    :goto_1
    invoke-virtual {v2}, Lorg/json/JSONException;->printStackTrace()V

    goto :goto_0

    .line 105
    .end local v0    # "customJson":Lorg/json/JSONObject;
    .end local v2    # "e":Lorg/json/JSONException;
    .restart local v1    # "customJson":Lorg/json/JSONObject;
    .restart local v4    # "myvalue":Ljava/lang/String;
    :catch_1
    move-exception v2

    move-object v0, v1

    .end local v1    # "customJson":Lorg/json/JSONObject;
    .restart local v0    # "customJson":Lorg/json/JSONObject;
    goto :goto_1
.end method

.method public onNotificationClicked(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 7
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "title"    # Ljava/lang/String;
    .param p3, "description"    # Ljava/lang/String;
    .param p4, "customContentString"    # Ljava/lang/String;

    .prologue
    .line 130
    new-instance v5, Ljava/lang/StringBuilder;

    const-string v6, "\u901a\u77e5\u70b9\u51fb title=\""

    invoke-direct {v5, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v5, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, "\" description=\""

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    .line 131
    invoke-virtual {v5, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, "\" customContent="

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    .line 130
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    .line 132
    .local v4, "notifyString":Ljava/lang/String;
    sget-object v5, Lorg/cocos2dx/lua/MyPushMessageReceiver;->TAG:Ljava/lang/String;

    invoke-static {v5, v4}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 135
    invoke-static {p4}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v5

    if-nez v5, :cond_0

    .line 136
    const/4 v0, 0x0

    .line 138
    .local v0, "customJson":Lorg/json/JSONObject;
    :try_start_0
    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1, p4}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V
    :try_end_0
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_0

    .line 139
    .end local v0    # "customJson":Lorg/json/JSONObject;
    .local v1, "customJson":Lorg/json/JSONObject;
    const/4 v3, 0x0

    .line 140
    .local v3, "myvalue":Ljava/lang/String;
    :try_start_1
    const-string v5, "mykey"

    invoke-virtual {v1, v5}, Lorg/json/JSONObject;->isNull(Ljava/lang/String;)Z

    move-result v5

    if-nez v5, :cond_0

    .line 141
    const-string v5, "mykey"

    invoke-virtual {v1, v5}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;
    :try_end_1
    .catch Lorg/json/JSONException; {:try_start_1 .. :try_end_1} :catch_1

    .line 150
    .end local v1    # "customJson":Lorg/json/JSONObject;
    .end local v3    # "myvalue":Ljava/lang/String;
    :cond_0
    :goto_0
    invoke-direct {p0, p1, v4}, Lorg/cocos2dx/lua/MyPushMessageReceiver;->updateContent(Landroid/content/Context;Ljava/lang/String;)V

    .line 151
    return-void

    .line 143
    .restart local v0    # "customJson":Lorg/json/JSONObject;
    :catch_0
    move-exception v2

    .line 145
    .local v2, "e":Lorg/json/JSONException;
    :goto_1
    invoke-virtual {v2}, Lorg/json/JSONException;->printStackTrace()V

    goto :goto_0

    .line 143
    .end local v0    # "customJson":Lorg/json/JSONObject;
    .end local v2    # "e":Lorg/json/JSONException;
    .restart local v1    # "customJson":Lorg/json/JSONObject;
    .restart local v3    # "myvalue":Ljava/lang/String;
    :catch_1
    move-exception v2

    move-object v0, v1

    .end local v1    # "customJson":Lorg/json/JSONObject;
    .restart local v0    # "customJson":Lorg/json/JSONObject;
    goto :goto_1
.end method

.method public onSetTags(Landroid/content/Context;ILjava/util/List;Ljava/util/List;Ljava/lang/String;)V
    .locals 3
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "errorCode"    # I
    .param p5, "requestId"    # Ljava/lang/String;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "I",
            "Ljava/util/List",
            "<",
            "Ljava/lang/String;",
            ">;",
            "Ljava/util/List",
            "<",
            "Ljava/lang/String;",
            ">;",
            "Ljava/lang/String;",
            ")V"
        }
    .end annotation

    .prologue
    .line 170
    .local p3, "sucessTags":Ljava/util/List;, "Ljava/util/List<Ljava/lang/String;>;"
    .local p4, "failTags":Ljava/util/List;, "Ljava/util/List<Ljava/lang/String;>;"
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "onSetTags errorCode="

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 171
    const-string v2, " sucessTags="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " failTags="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 172
    const-string v2, " requestId="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 170
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 173
    .local v0, "responseString":Ljava/lang/String;
    sget-object v1, Lorg/cocos2dx/lua/MyPushMessageReceiver;->TAG:Ljava/lang/String;

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 176
    invoke-direct {p0, p1, v0}, Lorg/cocos2dx/lua/MyPushMessageReceiver;->updateContent(Landroid/content/Context;Ljava/lang/String;)V

    .line 177
    return-void
.end method

.method public onUnbind(Landroid/content/Context;ILjava/lang/String;)V
    .locals 3
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "errorCode"    # I
    .param p3, "requestId"    # Ljava/lang/String;

    .prologue
    .line 240
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "onUnbind errorCode="

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 241
    const-string v2, " requestId = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 240
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 242
    .local v0, "responseString":Ljava/lang/String;
    sget-object v1, Lorg/cocos2dx/lua/MyPushMessageReceiver;->TAG:Ljava/lang/String;

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 245
    if-nez p2, :cond_0

    .line 246
    const/4 v1, 0x0

    invoke-static {p1, v1}, Lorg/cocos2dx/lua/MyUtils;->setBind(Landroid/content/Context;Z)V

    .line 249
    :cond_0
    invoke-direct {p0, p1, v0}, Lorg/cocos2dx/lua/MyPushMessageReceiver;->updateContent(Landroid/content/Context;Ljava/lang/String;)V

    .line 250
    return-void
.end method
