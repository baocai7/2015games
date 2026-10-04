.class Lcn/uc/gamesdk/UCGameSDK$3;
.super Ljava/lang/Object;

# interfaces
.implements Lcn/uc/gamesdk/UCCallbackListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcn/uc/gamesdk/UCGameSDK;->getUCVipInfo(Landroid/content/Context;Lcn/uc/gamesdk/UCCallbackListener;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Lcn/uc/gamesdk/UCCallbackListener",
        "<",
        "Lorg/json/JSONObject;",
        ">;"
    }
.end annotation


# instance fields
.field final synthetic a:Lcn/uc/gamesdk/UCCallbackListener;

.field final synthetic b:Lcn/uc/gamesdk/UCGameSDK;


# direct methods
.method constructor <init>(Lcn/uc/gamesdk/UCGameSDK;Lcn/uc/gamesdk/UCCallbackListener;)V
    .locals 0

    iput-object p1, p0, Lcn/uc/gamesdk/UCGameSDK$3;->b:Lcn/uc/gamesdk/UCGameSDK;

    iput-object p2, p0, Lcn/uc/gamesdk/UCGameSDK$3;->a:Lcn/uc/gamesdk/UCCallbackListener;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public bridge synthetic callback(ILjava/lang/Object;)V
    .locals 0

    check-cast p2, Lorg/json/JSONObject;

    invoke-virtual {p0, p1, p2}, Lcn/uc/gamesdk/UCGameSDK$3;->callback(ILorg/json/JSONObject;)V

    return-void
.end method

.method public callback(ILorg/json/JSONObject;)V
    .locals 9

    const/4 v3, 0x0

    const/4 v1, 0x0

    packed-switch p1, :pswitch_data_0

    iget-object v0, p0, Lcn/uc/gamesdk/UCGameSDK$3;->a:Lcn/uc/gamesdk/UCCallbackListener;

    invoke-interface {v0, p1, v3}, Lcn/uc/gamesdk/UCCallbackListener;->callback(ILjava/lang/Object;)V

    :goto_0
    return-void

    :pswitch_0
    new-instance v4, Lcn/uc/gamesdk/info/VipInfo;

    invoke-direct {v4}, Lcn/uc/gamesdk/info/VipInfo;-><init>()V

    new-instance v5, Ljava/util/ArrayList;

    invoke-direct {v5}, Ljava/util/ArrayList;-><init>()V

    const-string v0, "status"

    invoke-static {p2, v0, v1}, Lcn/uc/gamesdk/d/d;->a(Lorg/json/JSONObject;Ljava/lang/String;I)I

    move-result v0

    invoke-virtual {v4, v0}, Lcn/uc/gamesdk/info/VipInfo;->setStatus(I)V

    const-string v0, "cmbInfo"

    invoke-static {p2, v0, v3}, Lcn/uc/gamesdk/d/d;->a(Lorg/json/JSONObject;Ljava/lang/String;Lorg/json/JSONObject;)Lorg/json/JSONObject;

    move-result-object v0

    const-string v2, "grade"

    invoke-static {v0, v2, v1}, Lcn/uc/gamesdk/d/d;->a(Lorg/json/JSONObject;Ljava/lang/String;I)I

    move-result v2

    const-string v6, "validFrom"

    const-string v7, ""

    invoke-static {v0, v6, v7}, Lcn/uc/gamesdk/d/d;->a(Lorg/json/JSONObject;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    const-string v7, "validTo"

    const-string v8, ""

    invoke-static {v0, v7, v8}, Lcn/uc/gamesdk/d/d;->a(Lorg/json/JSONObject;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v4, v2}, Lcn/uc/gamesdk/info/VipInfo;->setGrade(I)V

    invoke-virtual {v4, v6}, Lcn/uc/gamesdk/info/VipInfo;->setValidFrom(Ljava/lang/String;)V

    invoke-virtual {v4, v0}, Lcn/uc/gamesdk/info/VipInfo;->setValidTo(Ljava/lang/String;)V

    const-string v0, "privs"

    invoke-static {p2, v0, v3}, Lcn/uc/gamesdk/d/d;->a(Lorg/json/JSONObject;Ljava/lang/String;Lorg/json/JSONArray;)Lorg/json/JSONArray;

    move-result-object v6

    if-eqz v6, :cond_0

    move v0, v1

    :goto_1
    invoke-virtual {v6}, Lorg/json/JSONArray;->length()I

    move-result v2

    if-ge v0, v2, :cond_0

    :try_start_0
    invoke-virtual {v6, v0}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;
    :try_end_0
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v2

    :goto_2
    const-string v7, "pId"

    const-string v8, ""

    invoke-static {v2, v7, v8}, Lcn/uc/gamesdk/d/d;->a(Lorg/json/JSONObject;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    const-string v8, "enjoy"

    invoke-static {v2, v8, v1}, Lcn/uc/gamesdk/d/d;->a(Lorg/json/JSONObject;Ljava/lang/String;I)I

    move-result v2

    new-instance v8, Lcn/uc/gamesdk/info/PrivilegeInfo;

    invoke-direct {v8}, Lcn/uc/gamesdk/info/PrivilegeInfo;-><init>()V

    invoke-virtual {v8, v7}, Lcn/uc/gamesdk/info/PrivilegeInfo;->setpId(Ljava/lang/String;)V

    invoke-virtual {v8, v2}, Lcn/uc/gamesdk/info/PrivilegeInfo;->setEnjoy(I)V

    invoke-virtual {v5, v8}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v0, v0, 0x1

    goto :goto_1

    :catch_0
    move-exception v2

    invoke-virtual {v2}, Lorg/json/JSONException;->printStackTrace()V

    move-object v2, v3

    goto :goto_2

    :cond_0
    invoke-virtual {v4, v5}, Lcn/uc/gamesdk/info/VipInfo;->setPrivilegeList(Ljava/util/ArrayList;)V

    iget-object v0, p0, Lcn/uc/gamesdk/UCGameSDK$3;->a:Lcn/uc/gamesdk/UCCallbackListener;

    invoke-interface {v0, p1, v4}, Lcn/uc/gamesdk/UCCallbackListener;->callback(ILjava/lang/Object;)V

    goto :goto_0

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
    .end packed-switch
.end method
