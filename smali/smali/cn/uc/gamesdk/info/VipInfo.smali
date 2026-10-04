.class public Lcn/uc/gamesdk/info/VipInfo;
.super Ljava/lang/Object;


# instance fields
.field private a:Z

.field private b:I

.field private c:I

.field private d:Ljava/lang/String;

.field private e:Ljava/lang/String;

.field private f:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList",
            "<",
            "Lcn/uc/gamesdk/info/PrivilegeInfo;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public getGrade()I
    .locals 1

    iget v0, p0, Lcn/uc/gamesdk/info/VipInfo;->c:I

    return v0
.end method

.method public getPrivilegeList()Ljava/util/ArrayList;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/ArrayList",
            "<",
            "Lcn/uc/gamesdk/info/PrivilegeInfo;",
            ">;"
        }
    .end annotation

    iget-object v0, p0, Lcn/uc/gamesdk/info/VipInfo;->f:Ljava/util/ArrayList;

    return-object v0
.end method

.method public getStatus()I
    .locals 1

    iget v0, p0, Lcn/uc/gamesdk/info/VipInfo;->b:I

    return v0
.end method

.method public getValidFrom()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcn/uc/gamesdk/info/VipInfo;->d:Ljava/lang/String;

    return-object v0
.end method

.method public getValidTo()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcn/uc/gamesdk/info/VipInfo;->e:Ljava/lang/String;

    return-object v0
.end method

.method public isError()Z
    .locals 1

    iget-boolean v0, p0, Lcn/uc/gamesdk/info/VipInfo;->a:Z

    return v0
.end method

.method public setGrade(I)V
    .locals 0

    iput p1, p0, Lcn/uc/gamesdk/info/VipInfo;->c:I

    return-void
.end method

.method public setPrivilegeList(Ljava/util/ArrayList;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/ArrayList",
            "<",
            "Lcn/uc/gamesdk/info/PrivilegeInfo;",
            ">;)V"
        }
    .end annotation

    iput-object p1, p0, Lcn/uc/gamesdk/info/VipInfo;->f:Ljava/util/ArrayList;

    return-void
.end method

.method public setStatus(I)V
    .locals 0

    iput p1, p0, Lcn/uc/gamesdk/info/VipInfo;->b:I

    return-void
.end method

.method public setValidFrom(Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcn/uc/gamesdk/info/VipInfo;->d:Ljava/lang/String;

    return-void
.end method

.method public setValidTo(Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcn/uc/gamesdk/info/VipInfo;->e:Ljava/lang/String;

    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 2

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "status:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget v1, p0, Lcn/uc/gamesdk/info/VipInfo;->b:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, ",grade:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget v1, p0, Lcn/uc/gamesdk/info/VipInfo;->c:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, ",validFrom:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-object v1, p0, Lcn/uc/gamesdk/info/VipInfo;->d:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, ",validTo:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-object v1, p0, Lcn/uc/gamesdk/info/VipInfo;->e:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, ",privilegeList:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-object v1, p0, Lcn/uc/gamesdk/info/VipInfo;->f:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method
