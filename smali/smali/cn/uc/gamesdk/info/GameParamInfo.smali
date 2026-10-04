.class public Lcn/uc/gamesdk/info/GameParamInfo;
.super Ljava/lang/Object;

# interfaces
.implements Ljava/io/Serializable;


# static fields
.field private static final a:J = -0xa9d17cee7f175aeL


# instance fields
.field private b:I

.field private c:I

.field private d:I

.field private e:I

.field private f:Lcn/uc/gamesdk/info/ExInfo;

.field private g:Ljava/lang/String;

.field private h:Lcn/uc/gamesdk/info/FeatureSwitch;

.field private transient i:Landroid/os/Bundle;


# direct methods
.method public constructor <init>()V
    .locals 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    new-instance v0, Lcn/uc/gamesdk/info/FeatureSwitch;

    invoke-direct {v0}, Lcn/uc/gamesdk/info/FeatureSwitch;-><init>()V

    iput-object v0, p0, Lcn/uc/gamesdk/info/GameParamInfo;->h:Lcn/uc/gamesdk/info/FeatureSwitch;

    new-instance v0, Landroid/os/Bundle;

    invoke-direct {v0}, Landroid/os/Bundle;-><init>()V

    iput-object v0, p0, Lcn/uc/gamesdk/info/GameParamInfo;->i:Landroid/os/Bundle;

    return-void
.end method


# virtual methods
.method public getChannelId()I
    .locals 1
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    iget v0, p0, Lcn/uc/gamesdk/info/GameParamInfo;->d:I

    return v0
.end method

.method public getCpId()I
    .locals 1

    iget v0, p0, Lcn/uc/gamesdk/info/GameParamInfo;->c:I

    return v0
.end method

.method public getDebugConfig()Landroid/os/Bundle;
    .locals 1

    iget-object v0, p0, Lcn/uc/gamesdk/info/GameParamInfo;->i:Landroid/os/Bundle;

    return-object v0
.end method

.method public getExInfo()Lcn/uc/gamesdk/info/ExInfo;
    .locals 1

    iget-object v0, p0, Lcn/uc/gamesdk/info/GameParamInfo;->f:Lcn/uc/gamesdk/info/ExInfo;

    return-object v0
.end method

.method public getFeatureSwitch()Lcn/uc/gamesdk/info/FeatureSwitch;
    .locals 1

    iget-object v0, p0, Lcn/uc/gamesdk/info/GameParamInfo;->h:Lcn/uc/gamesdk/info/FeatureSwitch;

    return-object v0
.end method

.method public getGameId()I
    .locals 1

    iget v0, p0, Lcn/uc/gamesdk/info/GameParamInfo;->b:I

    return v0
.end method

.method public getServerId()I
    .locals 1

    iget v0, p0, Lcn/uc/gamesdk/info/GameParamInfo;->e:I

    return v0
.end method

.method public getServerName()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcn/uc/gamesdk/info/GameParamInfo;->g:Ljava/lang/String;

    if-nez v0, :cond_0

    const-string v0, ""

    :goto_0
    return-object v0

    :cond_0
    iget-object v0, p0, Lcn/uc/gamesdk/info/GameParamInfo;->g:Ljava/lang/String;

    goto :goto_0
.end method

.method public setChannelId(I)V
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    iput p1, p0, Lcn/uc/gamesdk/info/GameParamInfo;->d:I

    return-void
.end method

.method public setCpId(I)V
    .locals 0

    iput p1, p0, Lcn/uc/gamesdk/info/GameParamInfo;->c:I

    return-void
.end method

.method public setDebugConfig(Landroid/os/Bundle;)V
    .locals 0

    iput-object p1, p0, Lcn/uc/gamesdk/info/GameParamInfo;->i:Landroid/os/Bundle;

    return-void
.end method

.method public setExInfo(Lcn/uc/gamesdk/info/ExInfo;)V
    .locals 0

    iput-object p1, p0, Lcn/uc/gamesdk/info/GameParamInfo;->f:Lcn/uc/gamesdk/info/ExInfo;

    return-void
.end method

.method public setFeatureSwitch(Lcn/uc/gamesdk/info/FeatureSwitch;)V
    .locals 0

    iput-object p1, p0, Lcn/uc/gamesdk/info/GameParamInfo;->h:Lcn/uc/gamesdk/info/FeatureSwitch;

    return-void
.end method

.method public setGameId(I)V
    .locals 0

    iput p1, p0, Lcn/uc/gamesdk/info/GameParamInfo;->b:I

    return-void
.end method

.method public setServerId(I)V
    .locals 0

    iput p1, p0, Lcn/uc/gamesdk/info/GameParamInfo;->e:I

    return-void
.end method

.method public setServerName(Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcn/uc/gamesdk/info/GameParamInfo;->g:Ljava/lang/String;

    return-void
.end method

.method public toBundleObject()Landroid/os/Bundle;
    .locals 3

    new-instance v0, Landroid/os/Bundle;

    invoke-direct {v0}, Landroid/os/Bundle;-><init>()V

    const-string v1, "cpId"

    iget v2, p0, Lcn/uc/gamesdk/info/GameParamInfo;->c:I

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putInt(Ljava/lang/String;I)V

    const-string v1, "gameId"

    iget v2, p0, Lcn/uc/gamesdk/info/GameParamInfo;->b:I

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putInt(Ljava/lang/String;I)V

    const-string v1, "serverId"

    iget v2, p0, Lcn/uc/gamesdk/info/GameParamInfo;->e:I

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putInt(Ljava/lang/String;I)V

    const-string v1, "enablePayHistory"

    iget-object v2, p0, Lcn/uc/gamesdk/info/GameParamInfo;->h:Lcn/uc/gamesdk/info/FeatureSwitch;

    invoke-virtual {v2}, Lcn/uc/gamesdk/info/FeatureSwitch;->isEnablePayHistory()Z

    move-result v2

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V

    const-string v1, "enableUserChange"

    iget-object v2, p0, Lcn/uc/gamesdk/info/GameParamInfo;->h:Lcn/uc/gamesdk/info/FeatureSwitch;

    invoke-virtual {v2}, Lcn/uc/gamesdk/info/FeatureSwitch;->isEnableUserChange()Z

    move-result v2

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V

    const-string v1, "debugConfig"

    invoke-virtual {p0}, Lcn/uc/gamesdk/info/GameParamInfo;->getDebugConfig()Landroid/os/Bundle;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putBundle(Ljava/lang/String;Landroid/os/Bundle;)V

    return-object v0
.end method
