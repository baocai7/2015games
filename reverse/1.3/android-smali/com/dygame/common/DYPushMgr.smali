.class public Lcom/dygame/common/DYPushMgr;
.super Ljava/lang/Object;
.source "DYPushMgr.java"


# static fields
.field private static mListener:I

.field private static mScriptListener:I


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    const/4 v0, -0x1

    .line 14
    sput v0, Lcom/dygame/common/DYPushMgr;->mScriptListener:I

    .line 15
    sput v0, Lcom/dygame/common/DYPushMgr;->mListener:I

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .prologue
    .line 13
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static delTags(Ljava/lang/String;)V
    .locals 4
    .param p0, "param"    # Ljava/lang/String;

    .prologue
    .line 68
    const-string v3, ";"

    invoke-virtual {p0, v3}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v1

    .line 69
    .local v1, "saTags":[Ljava/lang/String;
    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    .line 70
    .local v2, "tags":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Ljava/lang/String;>;"
    const/4 v0, 0x0

    .local v0, "i":I
    :goto_0
    array-length v3, v1

    if-ge v0, v3, :cond_0

    .line 71
    aget-object v3, v1, v0

    invoke-virtual {v2, v3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 70
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 73
    :cond_0
    sget-object v3, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    invoke-static {v3, v2}, Lcom/baidu/android/pushservice/PushManager;->delTags(Landroid/content/Context;Ljava/util/List;)V

    .line 74
    return-void
.end method

.method public static doEnable(Ljava/lang/String;)V
    .locals 6
    .param p0, "param"    # Ljava/lang/String;

    .prologue
    const/4 v5, 0x1

    .line 39
    :try_start_0
    new-instance v2, Lorg/json/JSONObject;

    invoke-direct {v2, p0}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 40
    .local v2, "jObj":Lorg/json/JSONObject;
    const-string v3, "flag"

    const/4 v4, 0x1

    invoke-virtual {v2, v3, v4}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;Z)Z

    move-result v3

    invoke-static {v3}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v1

    .line 41
    .local v1, "flag":Ljava/lang/Boolean;
    invoke-virtual {v1}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v3

    if-nez v3, :cond_1

    .line 42
    sget-object v3, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    invoke-virtual {v3}, Lcom/dygame/common/DYGame;->getApplicationContext()Landroid/content/Context;

    move-result-object v3

    invoke-static {v3}, Lcom/baidu/android/pushservice/PushManager;->stopWork(Landroid/content/Context;)V

    .line 51
    .end local v1    # "flag":Ljava/lang/Boolean;
    .end local v2    # "jObj":Lorg/json/JSONObject;
    :cond_0
    :goto_0
    return-void

    .line 44
    .restart local v1    # "flag":Ljava/lang/Boolean;
    .restart local v2    # "jObj":Lorg/json/JSONObject;
    :cond_1
    invoke-virtual {v1}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v3

    if-ne v3, v5, :cond_0

    .line 45
    sget-object v3, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    invoke-virtual {v3}, Lcom/dygame/common/DYGame;->getApplicationContext()Landroid/content/Context;

    move-result-object v3

    const/4 v4, 0x0

    sget-object v5, Lcom/dygame/open/baidu/DYBPushHelper;->API_KEY:Ljava/lang/String;

    invoke-static {v3, v4, v5}, Lcom/baidu/android/pushservice/PushManager;->startWork(Landroid/content/Context;ILjava/lang/String;)V
    :try_end_0
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 47
    .end local v1    # "flag":Ljava/lang/Boolean;
    .end local v2    # "jObj":Lorg/json/JSONObject;
    :catch_0
    move-exception v0

    .line 49
    .local v0, "e":Lorg/json/JSONException;
    invoke-virtual {v0}, Lorg/json/JSONException;->printStackTrace()V

    goto :goto_0
.end method

.method public static doInit(Ljava/lang/String;)V
    .locals 2
    .param p0, "param"    # Ljava/lang/String;

    .prologue
    .line 27
    sget v0, Lcom/dygame/common/DYPushMgr;->mListener:I

    .line 28
    .local v0, "listener":I
    const/4 v1, -0x1

    sput v1, Lcom/dygame/common/DYPushMgr;->mListener:I

    .line 30
    invoke-static {p0}, Lcom/dygame/common/DYPushMgr;->doEnable(Ljava/lang/String;)V

    .line 31
    const-string v1, "EVENT_INIT_SUCC"

    invoke-static {v1, p0, v0}, Lcom/dygame/common/DYCommon;->notifyScriptListener(Ljava/lang/String;Ljava/lang/String;I)V

    .line 32
    return-void
.end method

.method public static enable(Ljava/lang/String;)V
    .locals 2
    .param p0, "param"    # Ljava/lang/String;

    .prologue
    .line 35
    const-class v0, Lcom/dygame/common/DYPushMgr;

    const-string v1, "doEnable"

    invoke-static {v0, v1, p0}, Lcom/dygame/common/DYThreadHelper;->runStaticFunctionOnUIThread(Ljava/lang/Class;Ljava/lang/String;Ljava/lang/String;)V

    .line 36
    return-void
.end method

.method public static init(Ljava/lang/String;I)V
    .locals 2
    .param p0, "param"    # Ljava/lang/String;
    .param p1, "listener"    # I

    .prologue
    .line 19
    sget v0, Lcom/dygame/common/DYPushMgr;->mListener:I

    const/4 v1, -0x1

    if-eq v0, v1, :cond_0

    .line 20
    const-string v0, "EVENT_INIT_FAIL"

    invoke-static {v0, p0, p1}, Lcom/dygame/common/DYCommon;->notifyScriptListener(Ljava/lang/String;Ljava/lang/String;I)V

    .line 22
    :cond_0
    sput p1, Lcom/dygame/common/DYPushMgr;->mListener:I

    .line 23
    const-class v0, Lcom/dygame/common/DYPushMgr;

    const-string v1, "doInit"

    invoke-static {v0, v1, p0}, Lcom/dygame/common/DYThreadHelper;->runStaticFunctionOnUIThread(Ljava/lang/Class;Ljava/lang/String;Ljava/lang/String;)V

    .line 24
    return-void
.end method

.method protected static onPushMessage(Ljava/lang/String;)V
    .locals 2
    .param p0, "message"    # Ljava/lang/String;

    .prologue
    .line 78
    sget v0, Lcom/dygame/common/DYPushMgr;->mScriptListener:I

    const/4 v1, -0x1

    if-eq v0, v1, :cond_0

    .line 79
    sget v0, Lcom/dygame/common/DYPushMgr;->mScriptListener:I

    invoke-static {v0, p0}, Lorg/cocos2dx/lib/Cocos2dxLuaJavaBridge;->callLuaFunctionWithString(ILjava/lang/String;)I

    .line 81
    :cond_0
    return-void
.end method

.method public static regScriptListener(I)V
    .locals 0
    .param p0, "listener"    # I

    .prologue
    .line 54
    sput p0, Lcom/dygame/common/DYPushMgr;->mScriptListener:I

    .line 55
    return-void
.end method

.method public static setTags(Ljava/lang/String;)V
    .locals 4
    .param p0, "param"    # Ljava/lang/String;

    .prologue
    .line 60
    const-string v3, ";"

    invoke-virtual {p0, v3}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v1

    .line 61
    .local v1, "saTags":[Ljava/lang/String;
    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    .line 62
    .local v2, "tags":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Ljava/lang/String;>;"
    const/4 v0, 0x0

    .local v0, "i":I
    :goto_0
    array-length v3, v1

    if-ge v0, v3, :cond_0

    .line 63
    aget-object v3, v1, v0

    invoke-virtual {v2, v3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 62
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 65
    :cond_0
    sget-object v3, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    invoke-static {v3, v2}, Lcom/baidu/android/pushservice/PushManager;->setTags(Landroid/content/Context;Ljava/util/List;)V

    .line 66
    return-void
.end method

.method public static unregScriptListener()V
    .locals 1

    .prologue
    .line 57
    const/4 v0, -0x1

    sput v0, Lcom/dygame/common/DYPushMgr;->mScriptListener:I

    .line 58
    return-void
.end method
