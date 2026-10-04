.class public Lcn/uc/gamesdk/info/UCFriendList;
.super Ljava/lang/Object;


# instance fields
.field private a:I

.field private b:I

.field private c:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList",
            "<",
            "Lcn/uc/gamesdk/info/UCFriendInfo;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public constructor <init>()V
    .locals 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    iput v0, p0, Lcn/uc/gamesdk/info/UCFriendList;->b:I

    const/4 v0, 0x0

    iput-object v0, p0, Lcn/uc/gamesdk/info/UCFriendList;->c:Ljava/util/ArrayList;

    return-void
.end method


# virtual methods
.method public getEntityList()Ljava/util/ArrayList;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/ArrayList",
            "<",
            "Lcn/uc/gamesdk/info/UCFriendInfo;",
            ">;"
        }
    .end annotation

    iget-object v0, p0, Lcn/uc/gamesdk/info/UCFriendList;->c:Ljava/util/ArrayList;

    return-object v0
.end method

.method public getStatus()I
    .locals 1

    iget v0, p0, Lcn/uc/gamesdk/info/UCFriendList;->a:I

    return v0
.end method

.method public getTotalCount()I
    .locals 1

    iget v0, p0, Lcn/uc/gamesdk/info/UCFriendList;->b:I

    return v0
.end method

.method public setEntityList(Ljava/util/ArrayList;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/ArrayList",
            "<",
            "Lcn/uc/gamesdk/info/UCFriendInfo;",
            ">;)V"
        }
    .end annotation

    iput-object p1, p0, Lcn/uc/gamesdk/info/UCFriendList;->c:Ljava/util/ArrayList;

    return-void
.end method

.method public setStatus(I)V
    .locals 0

    iput p1, p0, Lcn/uc/gamesdk/info/UCFriendList;->a:I

    return-void
.end method

.method public setTotalCount(I)V
    .locals 0

    iput p1, p0, Lcn/uc/gamesdk/info/UCFriendList;->b:I

    return-void
.end method
