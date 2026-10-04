.class public Lcn/uc/gamesdk/info/FeatureSwitch;
.super Ljava/lang/Object;

# interfaces
.implements Ljava/io/Serializable;


# static fields
.field private static final a:J = 0x78658c1a63377750L


# instance fields
.field private b:Z

.field private c:Z


# direct methods
.method public constructor <init>()V
    .locals 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x1

    iput-boolean v0, p0, Lcn/uc/gamesdk/info/FeatureSwitch;->b:Z

    const/4 v0, 0x0

    iput-boolean v0, p0, Lcn/uc/gamesdk/info/FeatureSwitch;->c:Z

    return-void
.end method

.method public constructor <init>(ZZ)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-boolean p1, p0, Lcn/uc/gamesdk/info/FeatureSwitch;->b:Z

    iput-boolean p2, p0, Lcn/uc/gamesdk/info/FeatureSwitch;->c:Z

    return-void
.end method


# virtual methods
.method public isEnablePayHistory()Z
    .locals 1

    iget-boolean v0, p0, Lcn/uc/gamesdk/info/FeatureSwitch;->b:Z

    return v0
.end method

.method public isEnableUserChange()Z
    .locals 1

    iget-boolean v0, p0, Lcn/uc/gamesdk/info/FeatureSwitch;->c:Z

    return v0
.end method

.method public setEnablePayHistory(Z)V
    .locals 0

    iput-boolean p1, p0, Lcn/uc/gamesdk/info/FeatureSwitch;->b:Z

    return-void
.end method

.method public setEnableUserChange(Z)V
    .locals 0

    iput-boolean p1, p0, Lcn/uc/gamesdk/info/FeatureSwitch;->c:Z

    return-void
.end method
