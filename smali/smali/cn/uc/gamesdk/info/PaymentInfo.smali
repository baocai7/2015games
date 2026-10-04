.class public Lcn/uc/gamesdk/info/PaymentInfo;
.super Ljava/lang/Object;

# interfaces
.implements Ljava/io/Serializable;


# static fields
.field private static final a:J = -0x2d8ae64a0491c197L


# instance fields
.field private b:I

.field private c:Z

.field private d:F

.field private e:Ljava/lang/String;

.field private f:Ljava/lang/String;

.field private g:Ljava/lang/String;

.field private h:Ljava/lang/String;

.field private i:Ljava/lang/String;

.field private j:Ljava/lang/String;


# direct methods
.method public constructor <init>()V
    .locals 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    iput v0, p0, Lcn/uc/gamesdk/info/PaymentInfo;->b:I

    const/4 v0, 0x1

    iput-boolean v0, p0, Lcn/uc/gamesdk/info/PaymentInfo;->c:Z

    const/4 v0, 0x0

    iput v0, p0, Lcn/uc/gamesdk/info/PaymentInfo;->d:F

    return-void
.end method


# virtual methods
.method public getAmount()F
    .locals 1

    iget v0, p0, Lcn/uc/gamesdk/info/PaymentInfo;->d:F

    return v0
.end method

.method public getCustomInfo()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcn/uc/gamesdk/info/PaymentInfo;->h:Ljava/lang/String;

    return-object v0
.end method

.method public getGrade()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcn/uc/gamesdk/info/PaymentInfo;->g:Ljava/lang/String;

    return-object v0
.end method

.method public getNotifyUrl()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcn/uc/gamesdk/info/PaymentInfo;->i:Ljava/lang/String;

    return-object v0
.end method

.method public getRoleId()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcn/uc/gamesdk/info/PaymentInfo;->e:Ljava/lang/String;

    return-object v0
.end method

.method public getRoleName()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcn/uc/gamesdk/info/PaymentInfo;->f:Ljava/lang/String;

    return-object v0
.end method

.method public getServerId()I
    .locals 1

    iget v0, p0, Lcn/uc/gamesdk/info/PaymentInfo;->b:I

    return v0
.end method

.method public getTransactionNumCP()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcn/uc/gamesdk/info/PaymentInfo;->j:Ljava/lang/String;

    return-object v0
.end method

.method public isAllowContinuousPay()Z
    .locals 1

    iget-boolean v0, p0, Lcn/uc/gamesdk/info/PaymentInfo;->c:Z

    return v0
.end method

.method public setAllowContinuousPay(Z)V
    .locals 0

    iput-boolean p1, p0, Lcn/uc/gamesdk/info/PaymentInfo;->c:Z

    return-void
.end method

.method public setAmount(F)V
    .locals 0

    iput p1, p0, Lcn/uc/gamesdk/info/PaymentInfo;->d:F

    return-void
.end method

.method public setCustomInfo(Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcn/uc/gamesdk/info/PaymentInfo;->h:Ljava/lang/String;

    return-void
.end method

.method public setGrade(Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcn/uc/gamesdk/info/PaymentInfo;->g:Ljava/lang/String;

    return-void
.end method

.method public setNotifyUrl(Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcn/uc/gamesdk/info/PaymentInfo;->i:Ljava/lang/String;

    return-void
.end method

.method public setRoleId(Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcn/uc/gamesdk/info/PaymentInfo;->e:Ljava/lang/String;

    return-void
.end method

.method public setRoleName(Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcn/uc/gamesdk/info/PaymentInfo;->f:Ljava/lang/String;

    return-void
.end method

.method public setServerId(I)V
    .locals 0

    iput p1, p0, Lcn/uc/gamesdk/info/PaymentInfo;->b:I

    return-void
.end method

.method public setTransactionNumCP(Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcn/uc/gamesdk/info/PaymentInfo;->j:Ljava/lang/String;

    return-void
.end method
